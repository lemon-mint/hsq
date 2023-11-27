//go:build darwin || freebsd
// +build darwin freebsd

package shm

import (
	"os"
	"runtime"
	"syscall"
	"unsafe"
)

func shmOpen(name string, oflag int, mode os.FileMode) (fd int, err error) {
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

func shmUnlink(name string) error {
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

func OpenSharedMemory(name string, size int, flags int, mode os.FileMode) (*SharedMemory, error) {
	s := &SharedMemory{
		name: name,
		size: size,
	}

	fd, err := shmOpen(name, flags, mode)
	if err != nil {
		return nil, err
	}
	s.fd = uintptr(fd)

	if flags&os.O_CREATE != 0 {
		err = syscall.Ftruncate(fd, int64(size))
		if err != nil {
			return nil, err
		}
	}

	return s, nil
}

func (s *SharedMemory) Delete() error {
	return shmUnlink(s.name)
}

func (s *SharedMemory) Close() error {
	return syscall.Close(int(s.fd))
}
