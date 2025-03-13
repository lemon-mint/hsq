package main

import (
	"context"
	"log"
	"os"
	"os/signal"
	"time"
	"unsafe"

	"github.com/lemon-mint/hsq/internal/example/common"
	"github.com/lemon-mint/hsq/internal/mmap"
	"github.com/lemon-mint/hsq/internal/offheap/ring"
	"github.com/lemon-mint/hsq/internal/shm"
)

func main() {
	defer func() {
		if r := recover(); r != nil {
			log.Printf("recovered from panic: %v", r)
		}
	}()

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	memorySize := ring.SizeMPMCRing[[common.MPMCChunkSize]byte](common.SharedMemoryQueueLength)
	log.Printf("memory size is %v", memorySize)

	sm, err := shm.OpenSharedMemory(common.SharedMemoryName, int(memorySize), common.SharedMemoryReceiverFlags, common.SharedMemoryMode)
	if err != nil {
		log.Printf("failed to open shared memory: %v", err)
		return
	}
	defer sm.Delete()
	defer sm.Close()

	mm, err := mmap.Map(sm.FD(), 0, int(memorySize), mmap.PROT_READ|mmap.PROT_WRITE, mmap.MAP_SHARED)
	if err != nil {
		log.Printf("mmap error: %v", err)
		return
	}
	defer mmap.UnMap(mm)

	log.Printf("mmap size is %v", len(mm))

	ptr := uintptr(unsafe.Pointer(&mm[0]))
	if !ring.MPMCInit[[common.MPMCChunkSize]byte](ptr, common.SharedMemoryQueueLength) {
		log.Printf("failed to init buffer")
		return
	}

	r := ring.MPMCAttach[[common.MPMCChunkSize]byte](ptr, 0)

	done := ctx.Done()
	for {
		select {
		case <-done:
			log.Printf("receiver stopped")
			return
		default:
			func() {
				ctx, cancel := context.WithTimeout(ctx, time.Second)
				defer cancel()

				log.Printf("wait to receive")
				data, ok := r.DequeueWithContext(ctx)
				if ok {
					log.Printf("received data: %v", data)
				}
			}()
		}
	}
}
