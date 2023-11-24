//go:build darwin || freebsd
// +build darwin freebsd

package shm

import (
	"os"
	"runtime"
	"syscall"
	"unsafe"
)

func ShmOpen(name string, oflag int, mode os.FileMode) (fd int, err error) {
	b, err := syscall.BytePtrFromString(name)
	if err != nil {
		return 0, err
	}

	f, _, errno := syscall.Syscall(
		syscall.SYS_SHM_OPEN,
		uintptr(unsafe.Pointer(b)),
		uintptr(oflag),
		uintptr(mode),
	)
	runtime.KeepAlive(b)

	if errno != 0 {
		return 0, errno
	}
	return int(f), nil
}

func ShmUnlink(name string) error {
	b, err := syscall.BytePtrFromString(name)
	if err != nil {
		return err
	}

	_, _, errno := syscall.Syscall(
		syscall.SYS_SHM_UNLINK,
		uintptr(unsafe.Pointer(b)),
		0, 0,
	)
	runtime.KeepAlive(b)

	if errno != 0 {
		return errno
	}
	return nil
}
