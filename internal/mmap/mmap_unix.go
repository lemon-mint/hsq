//go:build unix || linux || darwin || freebsd || openbsd
// +build unix linux darwin freebsd openbsd

package mmap

import "syscall"

func Map(fd int, offset int, len int, prot int, flags int) ([]byte, error) {
	return syscall.Mmap(fd, int64(offset), len, prot, flags)
}

func UnMap(b []byte) error {
	return syscall.Munmap(b)
}
