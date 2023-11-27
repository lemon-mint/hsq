//go:build !linux && !freebsd && !darwin && !windows
// +build !linux,!freebsd,!darwin,!windows

package shm

import (
	"os"
	"syscall"
)

func shmOpen(name string, oflag int, mode os.FileMode) (fd int, err error) {
	return 0, syscall.ENOSYS
}

func shmUnlink(name string) error {
	return syscall.ENOSYS
}

func OpenSharedMemory(name string, size int, flags int, mode os.FileMode) (*SharedMemory, error) {
	return nil, syscall.ENOSYS
}

func (s *SharedMemory) Delete() error {
	return nil
}

func (s *SharedMemory) Close() error {
	return nil
}
