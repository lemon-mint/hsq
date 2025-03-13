package main

import (
	"context"
	"crypto/rand"
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

	sm, err := shm.OpenSharedMemory(common.SharedMemoryName, int(memorySize), common.SharedMemorySenderFlags, common.SharedMemoryMode)
	if err != nil {
		log.Printf("failed to open shared memory: %v", err)
		return
	}
	defer sm.Close()

	mm, err := mmap.Map(sm.FD(), 0, int(memorySize), mmap.PROT_READ|mmap.PROT_WRITE, mmap.MAP_SHARED)
	if err != nil {
		log.Printf("mmap error: %v", err)
		return
	}
	defer mmap.UnMap(mm)

	log.Printf("mmap size is %v", len(mm))

	ptr := uintptr(unsafe.Pointer(&mm[0]))
	r := ring.MPMCAttach[[common.MPMCChunkSize]byte](ptr, 0)

	done := ctx.Done()
	ticker := time.NewTicker(time.Second)
	for {
		select {
		case <-done:
			log.Printf("receiver stopped")
			return
		case <-ticker.C:
			func() {
				ctx, cancel := context.WithTimeout(ctx, time.Second)
				defer cancel()

				data := [common.MPMCChunkSize]byte{}
				rand.Read(data[:])
				r.EnqueueWithContext(ctx, data)
				log.Printf("sent data: %v", data)
			}()
		}
	}
}
