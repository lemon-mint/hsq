//go:build linux
// +build linux

package shm

import (
	"os"
	"path/filepath"
	"syscall"
)

func ShmOpen(name string, oflag int, mode os.FileMode) (fd int, err error) {
	return syscall.Open(filepath.Join("/dev/shm", name), int(oflag), uint32(mode))
}

func ShmUnlink(name string) error {
	return syscall.Unlink(filepath.Join("/dev/shm", name))
}
