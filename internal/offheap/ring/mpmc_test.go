package ring_test

import (
	"sync"
	"testing"
	"unsafe"

	"github.com/lemon-mint/hsq/internal/offheap/ring"
)

func TestMPMC(t *testing.T) {
	const size = 128
	buffer := make([]byte, ring.SizeMPMCRing[uintptr](size))
	b := uintptr(unsafe.Pointer(&buffer[0]))
	if !ring.MPMCInit[uintptr](b, size) {
		panic("failed to initialize offheap mpmc ring")
	}
	r := ring.MPMCAttach[uintptr](b, 0)
	for i := uintptr(0); i < size; i++ {
		r.Enqueue(i)
	}
	for i := uintptr(0); i < size; i++ {
		n := r.Dequeue()
		if n != i {
			panic("queue sequence violation")
		}
	}
}

func TestMPMCFunc(t *testing.T) {
	const size = 128
	buffer := make([]byte, ring.SizeMPMCRing[uintptr](size))
	b := uintptr(unsafe.Pointer(&buffer[0]))
	if !ring.MPMCInit[uintptr](b, size) {
		panic("failed to initialize offheap mpmc ring")
	}
	r := ring.MPMCAttach[uintptr](b, 0)
	for i := uintptr(0); i < size; i++ {
		r.EnqueueFunc(func(v *uintptr) {
			*v = i
		})
	}

	for i := uintptr(0); i < size; i++ {
		r.DequeueFunc(func(t *uintptr) {
			if *t != i {
				panic("queue sequence violation")
			}
		})
	}
}

func TestMPMCParallel(t *testing.T) {
	const size = 1 << 10
	buffer := make([]byte, ring.SizeMPMCRing[uintptr](size))
	b := uintptr(unsafe.Pointer(&buffer[0]))
	if !ring.MPMCInit[uintptr](b, size) {
		panic("failed to initialize offheap mpmc ring")
	}

	var mue, mud sync.Mutex
	var EnqueueMap, DequeueMap [(size + 63) / 64]uint64
	var wg sync.WaitGroup
	wg.Add(size * 2)

	for i := uintptr(0); i < size; i++ {
		// Spawn Enqueue goroutine.
		go func(i uintptr) {
			defer wg.Done()
			r := ring.MPMCAttach[uintptr](b, 0)
			r.Enqueue(i)

			mue.Lock()
			EnqueueMap[i/64] |= 1 << (i % 64)
			mue.Unlock()
		}(i)

		// Spawn Dequeue goroutine.
		go func() {
			defer wg.Done()
			r := ring.MPMCAttach[uintptr](b, 0)
			v := r.Dequeue()

			mud.Lock()
			DequeueMap[v/64] |= 1 << (v % 64)
			mud.Unlock()
		}()
	}

	// Wait for all goroutines to finish.
	wg.Wait()

	for i := uintptr(0); i < size; i++ {
		if EnqueueMap[i/64]&(1<<(i%64)) == 0 {
			t.Errorf("Enqueue Failed at index: %d", i)
			t.Fail()
		}
		if DequeueMap[i/64]&(1<<(i%64)) == 0 {
			t.Errorf("Dequeue Failed at index: %d", i)
			t.Fail()
		}
	}
}

func BenchmarkMPMC(b *testing.B) {
	const size = 128
	buffer := make([]byte, ring.SizeMPMCRing[uintptr](size))
	bb := uintptr(unsafe.Pointer(&buffer[0]))
	if !ring.MPMCInit[uintptr](bb, size) {
		panic("failed to initialize offheap mpmc ring")
	}
	b.RunParallel(func(p *testing.PB) {
		r := ring.MPMCAttach[uintptr](bb, 0)
		for p.Next() {
			r.Enqueue(0)
			_ = r.Dequeue()
		}
	})
}
