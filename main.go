package main

import (
	"fmt"
	"os"
	"os/signal"
	"sync"
	"sync/atomic"
	"syscall"
	"unsafe"

	"github.com/lemon-mint/hsq/internal/mmap"
	"github.com/lemon-mint/hsq/internal/shm"
	"github.com/lemon-mint/hsq/offheap/ring"
	"golang.org/x/sys/unix"
)

var pagesize = syscall.Getpagesize()

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: hsq <p|c>")
		os.Exit(1)
	}

	fd, err := shm.ShmOpen("/hsq", os.O_CREATE|os.O_RDWR, 0666)
	if err != nil {
		panic(fd)
	}
	defer shm.ShmUnlink("/hsq")
	defer syscall.Close(fd)
	const required = 256 + 16*256
	size := ((required + pagesize - 1) / pagesize) * pagesize
	if os.Args[1] == "p" {
		err = syscall.Ftruncate(fd, int64(size))
		if err != nil {
			panic(err)
		}
	}

	m, err := mmap.Map(fd, 0, size, unix.PROT_READ|unix.PROT_WRITE, unix.MAP_SHARED)
	if err != nil {
		panic(err)
	}
	defer mmap.UnMap(m)

	var wg sync.WaitGroup
	var stop uint32

	wg.Add(1)
	go func() {
		defer wg.Done()
		h := uintptr(unsafe.Pointer(&m[0]))

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
