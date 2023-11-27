package main

import (
	"fmt"
	"os"
	"os/signal"
	"sync"
	"sync/atomic"
	"syscall"
	"unsafe"

	"github.com/lemon-mint/hsq/offheap/ring"
	"github.com/lemon-mint/hsq/shm"
	"github.com/lemon-mint/hsq/shm/mmap"
)

var pagesize = syscall.Getpagesize()

func main() {
	if len(os.Args) < 2 || os.Args[1] != "p" && os.Args[1] != "c" {
		fmt.Println("Usage: hsq <p|c>")
		os.Exit(1)
	}

	var sm *shm.SharedMemory
	var err error
	var b []byte

	const required = 256 + 16*256
	size := ((required + pagesize - 1) / pagesize) * pagesize

	if os.Args[1] == "p" {
		sm, err = shm.OpenSharedMemory("/hsq", size, os.O_RDWR|os.O_CREATE, 0600)
		if err != nil {
			panic(err)
		}
		defer sm.Delete()
		defer sm.Close()
	} else if os.Args[1] == "c" {
		sm, err = shm.OpenSharedMemory("/hsq", size, os.O_RDWR, 0600)
		if err != nil {
			panic(err)
		}
		defer sm.Close()
	}

	b, err = mmap.Map(sm.FD(), 0, size, mmap.PROT_READ|mmap.PROT_WRITE, mmap.MAP_SHARED)
	if err != nil {
		panic(err)
	}
	defer mmap.UnMap(b)

	var wg sync.WaitGroup
	var stop uint32

	wg.Add(1)
	go func() {
		defer wg.Done()
		h := uintptr(unsafe.Pointer(unsafe.SliceData(b)))

		if os.Args[1] == "p" {
			ring.MPMCInit(h, 256)
			r := ring.MPMCAttach(h, 0)
			i := 0
			for {
				if atomic.LoadUint32(&stop) == 1 {
					return
				}

				r.Enqueue(uintptr(i))
				fmt.Println(i)
				i++
			}
		}
		if os.Args[1] == "c" {
			if atomic.LoadUint32(&stop) == 1 {
				return
			}

			r := ring.MPMCAttach(h, 0)
			for {
				fmt.Println(r.Dequeue())
			}
		}
	}()

	sc := make(chan os.Signal, 1)
	signal.Notify(sc, syscall.SIGTERM, os.Interrupt)
	<-sc
	atomic.StoreUint32(&stop, 1)
	wg.Wait()
}
