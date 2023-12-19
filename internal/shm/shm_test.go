package shm_test

import (
	"os"
	"syscall"
	"testing"

	"github.com/lemon-mint/hsq/internal/mmap"
	"github.com/lemon-mint/hsq/internal/shm"
)

var pagesize = syscall.Getpagesize()

func TestSharedMemory(t *testing.T) {
	sm, err := shm.OpenSharedMemory("/hsqtest1", pagesize, os.O_RDWR|os.O_CREATE, 0600)
	if err != nil {
		t.Fatal(err)
	}
	defer sm.Delete()
	defer sm.Close()
}

func TestSharedMemoryMap(t *testing.T) {
	sm, err := shm.OpenSharedMemory("/hsqtest2", pagesize, os.O_RDWR|os.O_CREATE, 0600)
	if err != nil {
		t.Fatal(err)
	}
	defer sm.Delete()
	defer sm.Close()

	println("fd:", sm.FD())
	b, err := mmap.Map(sm.FD(), 0, pagesize, mmap.PROT_READ|mmap.PROT_WRITE, mmap.MAP_SHARED)
	if err != nil {
		t.Fatal(err)
	}
	defer mmap.UnMap(b)

	for i := 0; i < pagesize; i++ {
		b[i] = byte(i)
	}
}
