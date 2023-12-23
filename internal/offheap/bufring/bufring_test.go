package bufring_test

import (
	"runtime"
	"testing"
	"unsafe"

	"github.com/lemon-mint/hsq/internal/offheap/bufring"
)

func TestBufferRing(t *testing.T) {
	size := bufring.SizeBufferRing(128, 4096)
	buffer := make([]byte, size)

	ring := bufring.NewBufferRing(uintptr(unsafe.Pointer(&buffer[0])), 128, 4096, false)
	hw := []byte("Hello, World!")

	ring.Send(func(b []byte) []byte {
		b = b[:0]
		return append(b, hw...)
	})

	ring.Receive(func(b []byte) {
		if string(b) != "Hello, World!" {
			t.Fatalf("unexpected message: %q, want %q", string(b), "Hello, World!")
		}
	})

	runtime.KeepAlive(&buffer[0])
}

func TestBufferRingCopy(t *testing.T) {
	size := bufring.SizeBufferRing(128, 4096)
	buffer := make([]byte, size)

	ring := bufring.NewBufferRing(uintptr(unsafe.Pointer(&buffer[0])), 128, 4096, false)
	hw := []byte("Hello, World!")

	ring.Send(func(b []byte) []byte {
		return hw
	})

	ring.Receive(func(b []byte) {
		if string(b) != "Hello, World!" {
			t.Fatalf("unexpected message: %q, want %q", string(b), "Hello, World!")
		}
	})

	runtime.KeepAlive(&buffer[0])
}

func TestBufferRingNil0(t *testing.T) {
	size := bufring.SizeBufferRing(128, 4096)
	buffer := make([]byte, size)

	ring := bufring.NewBufferRing(uintptr(unsafe.Pointer(&buffer[0])), 128, 4096, false)

	ring.Send(func(b []byte) []byte {
		return nil
	})

	ring.Receive(func(b []byte) {
		if len(b) != 0 {
			t.Fatalf("unexpected message length: %d, want %d", len(b), 0)
		}
	})

	runtime.KeepAlive(&buffer[0])
}

func TestBufferRingNil1(t *testing.T) {
	size := bufring.SizeBufferRing(128, 4096)
	buffer := make([]byte, size)

	ring := bufring.NewBufferRing(uintptr(unsafe.Pointer(&buffer[0])), 128, 4096, true)
	hw := []byte("Hello, World!")

	ring.Send(func(b []byte) []byte {
		return nil
	})

	ring.Send(func(b []byte) []byte {
		return append(b[:0], hw...)
	})

	ring.Send(func(b []byte) []byte {
		return nil
	})

	ring.Send(func(b []byte) []byte {
		return append(b[:0], hw...)
	})

	ring.Receive(func(b []byte) {
		if string(b) != "Hello, World!" {
			t.Fatalf("unexpected message: %q, want %q", string(b), "Hello, World!")
		}
	})

	ring.Receive(func(b []byte) {
		if string(b) != "Hello, World!" {
			t.Fatalf("unexpected message: %q, want %q", string(b), "Hello, World!")
		}
	})

	runtime.KeepAlive(&buffer[0])
}

func BenchmarkBufferRing(b *testing.B) {
	size := bufring.SizeBufferRing(128, 8388480)
	buffer := make([]byte, size)
	bufring.NewBufferRing(uintptr(unsafe.Pointer(&buffer[0])), 128, 8388480, false) // Init BufferRing
	b.SetBytes(int64(size))
	runtime.GC()
	b.ResetTimer()

	b.RunParallel(func(p *testing.PB) {
		ring := bufring.NewBufferRing(uintptr(unsafe.Pointer(&buffer[0])), 128, 8388480, false)
		var v byte

		for p.Next() {
			ring.Send(func(b []byte) []byte {
				for i := range b {
					b[i] = byte(i)
				}
				return b
			})

			ring.Receive(func(b []byte) {
				for i := range b {
					v = b[i]
				}
			})
		}

		_ = v
	})
}
