package ring_test

import (
	"testing"
	"unsafe"

	"github.com/lemon-mint/hsq/offheap/ring"
)

func TestMPMC(t *testing.T) {
	const size = 128
	buffer := make([]byte, 256+16*size)
	b := uintptr(unsafe.Pointer(&buffer[0]))
	if !ring.MPMCInit(b, size) {
		panic("failed to initialize offheap mpmc ring")
	}
	r := ring.MPMCAttach(b, 0)
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
	buffer := make([]byte, 256+16*size)
	bb := uintptr(unsafe.Pointer(&buffer[0]))
	if !ring.MPMCInit(bb, size) {
		panic("failed to initialize offheap mpmc ring")
	}
	b.RunParallel(func(p *testing.PB) {
		r := ring.MPMCAttach(bb, 0)
		for p.Next() {
			r.Enqueue(0)
			_ = r.Dequeue()
		}
	})
}
