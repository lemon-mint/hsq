//go:build windows
// +build windows

package shm

import (
	"os"
	"path/filepath"
	"runtime"
	"syscall"
	"unsafe"
)

var kernel32 = syscall.NewLazyDLL("Kernel32.dll")
var _CreateFileMappingW = kernel32.NewProc("CreateFileMappingW")
var _OpenFileMappingW = kernel32.NewProc("OpenFileMappingW")
var _MapViewOfFile = kernel32.NewProc("MapViewOfFile")

const ERROR_ALREADY_EXISTS syscall.Errno = 183

func nsCreateFileMapping(hFile syscall.Handle, lpFileMappingAttributes uintptr, flProtect uint32, MaximumSize uint64, lpName string) (syscall.Handle, error) {
	b, err := syscall.UTF16PtrFromString(lpName)
	if err != nil {
		return syscall.InvalidHandle, err
	}

	high := uint32(MaximumSize >> 32)
	low := uint32(MaximumSize & 0xffffffff)

	ret, _, err := _CreateFileMappingW.Call(
		uintptr(hFile),
		lpFileMappingAttributes,
		uintptr(flProtect),
		uintptr(high),
		uintptr(low),
		uintptr(unsafe.Pointer(b)),
	)
	runtime.KeepAlive(b)

	if ret == 0 || err == ERROR_ALREADY_EXISTS {
		// TODO: investigate case where ret == 0 && err == nil.
		return syscall.InvalidHandle, err
	}

	return syscall.Handle(ret), nil
}

func nsOpenFileMapping(dwDesiredAccess uint32, bInheritHandle bool, lpName string) (syscall.Handle, error) {
	b, err := syscall.UTF16PtrFromString(lpName)
	if err != nil {
		return syscall.InvalidHandle, err
	}

	inherit := 0
	if bInheritHandle {
		inherit = 1
	}

	ret, _, err := _OpenFileMappingW.Call(
		uintptr(dwDesiredAccess),
		uintptr(inherit),
		uintptr(unsafe.Pointer(b)),
	)
	runtime.KeepAlive(b)

	if ret == 0 {
		return syscall.InvalidHandle, err
	}

	return syscall.Handle(ret), nil
}

func OpenSharedMemory(name string, size int, flags int, mode os.FileMode) (*SharedMemory, error) {
	s := &SharedMemory{
		name: name,
		size: size,
	}

	_ = mode // Ignore FileMode
	name = filepath.Join("Global", name)

	if flags&os.O_CREATE != 0 {
		prot := 0
		if flags&os.O_RDWR != 0 {
			prot = syscall.PAGE_READWRITE
		} else if flags == os.O_RDONLY {
			prot = syscall.PAGE_READONLY
		}

		fd, err := nsCreateFileMapping(
			syscall.InvalidHandle,
			0,
			uint32(prot),
			uint64(size),
			name,
		)
		if err != nil && err != ERROR_ALREADY_EXISTS {
			return nil, err
		}

		if err != nil {
			s.fd = uintptr(fd)
			return s, nil
		}
	}

	fd, err := nsOpenFileMapping(
		0x02,
		false,
		name,
	)
	if err != nil {
		return nil, err
	}
	s.fd = uintptr(fd)

	return s, nil
}

func (s *SharedMemory) Delete() error {
	return nil // Do nothing
}

func (s *SharedMemory) Close() error {
	return syscall.CloseHandle(syscall.Handle(s.fd))
}
