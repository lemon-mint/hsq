package shm_test

import (
	"os"
	"syscall"
	"testing"

	"github.com/lemon-mint/hsq/internal/mmap"
	"github.com/lemon-mint/hsq/internal/shm"
	"golang.org/x/sys/unix"
)

var pagesize = syscall.Getpagesize()

func TestSharedMemory(t *testing.T) {
	fd, err := shm.ShmOpen("/hsq", os.O_CREATE|os.O_RDWR, 0666)
	if err != nil {
		t.Fatal(fd)
	}
	defer shm.ShmUnlink("/hsq")
	defer syscall.Close(fd)

	size := pagesize
	err = syscall.Ftruncate(fd, int64(size))
	if err != nil {
		t.Fatal(err)
	}

	m, err := mmap.Map(fd, 0, size, unix.PROT_READ|unix.PROT_WRITE, unix.MAP_SHARED)
	if err != nil {
		t.Fatal(err)
	}
	defer mmap.UnMap(m)

	m[0] = 1
}
