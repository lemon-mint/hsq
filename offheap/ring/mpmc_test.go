package ring_test

import (
	"testing"
	"unsafe"

	"github.com/lemon-mint/hsq/offheap/ring"
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
