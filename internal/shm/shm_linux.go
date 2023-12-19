//go:build linux
// +build linux

package shm

import (
	"os"
	"path/filepath"
	"syscall"
)

func shmOpen(name string, oflag int, mode os.FileMode) (fd int, err error) {
	return syscall.Open(filepath.Join("/dev/shm", name), int(oflag), uint32(mode))
}

func shmUnlink(name string) error {
	return syscall.Unlink(filepath.Join("/dev/shm", name))
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
