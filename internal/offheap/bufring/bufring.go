package bufring

import (
	"syscall"
	"time"
	"unsafe"

	"github.com/lemon-mint/hsq/internal/offheap/ring"
)

type _BUFFER_RING_MODE uint64

const (
	_BUFFER_RING_MODE_PRIMARY _BUFFER_RING_MODE = iota
	_BUFFER_RING_MODE_SECONDARY
)

type BufferRing struct {
	_RING_SIZE int
	_MAX_SIZE  int

	_ring ring.MPMCRing[_chunk]
	_mode _BUFFER_RING_MODE
	_head uintptr

	_ignore_nil bool
}

type _chunk struct {
	_pointer uintptr // relative pointer to the start of the buffer
	_size    uintptr // size of the chunk
}

var pagesize = syscall.Getpagesize()

func NewBufferRing(memory uintptr, ringsize int, maxsize int, ignore_nil bool) *BufferRing {
	if memory%8 != 0 || maxsize%8 != 0 {
		panic("bufring: memory alignment violation")
	}

	if ringsize < 1 || maxsize < 0 {
		panic("bufring: invalid buffer ring size")
	}

	_mpmc_size := ring.SizeMPMCRing[_chunk](uintptr(ringsize))
	_size := (_mpmc_size + uintptr(pagesize) - 1) / uintptr(pagesize) * uintptr(pagesize)

	r := &BufferRing{
		_RING_SIZE:  ringsize,
		_MAX_SIZE:   maxsize,
		_head:       memory,
		_ignore_nil: ignore_nil,
	}

	r._mode = _BUFFER_RING_MODE_SECONDARY
	if ring.MPMCInit[_chunk](memory, uint64(ringsize)) {
		r._mode = _BUFFER_RING_MODE_PRIMARY
	}

	_ring := ring.MPMCAttach[_chunk](memory, time.Second)
	if _ring == nil {
		panic("bufring: failed to attach buffer ring")
	}

	if r._mode == _BUFFER_RING_MODE_PRIMARY {
		for i := 0; i < ringsize; i++ {
			_ring.Enqueue(_chunk{
				_pointer: _size + uintptr(maxsize)*uintptr(i),
				_size:    uintptr(maxsize),
			})
		}
		for i := 0; i < ringsize; i++ {
			_ring.Dequeue()
		}
	}
	r._ring = *_ring

	return r
}

func SizeBufferRing(ringsize int, maxsize int) int {
	_mpmc_size := ring.SizeMPMCRing[_chunk](uintptr(ringsize))
	_size := (_mpmc_size + uintptr(pagesize) - 1) / uintptr(pagesize) * uintptr(pagesize)
	return int(_size + uintptr(maxsize)*uintptr(ringsize))
}

func (r *BufferRing) Size() int {
	return r._RING_SIZE
}

func (r *BufferRing) MaxBufferSize() int {
	return r._MAX_SIZE
}

func (r *BufferRing) Send(data func(b []byte) []byte) {
	r._ring.EnqueueFunc(func(c *_chunk) {
		addr := c._pointer + r._head
		b := unsafe.Slice((*byte)(unsafe.Pointer(addr)), r._MAX_SIZE)
		br := data(b)

		if br == nil {
			c._size = 0
			return
		}

		if uintptr(unsafe.Pointer(unsafe.SliceData(br))) != addr {
			if len(br) > r._MAX_SIZE {
				panic("bufring: buffer size violation")
			}
			c._size = uintptr(len(br))
			copy(b, br)
		}

		c._size = uintptr(len(br))
	})
}

func (r *BufferRing) Receive(data func(b []byte)) {
retry:
	nodata := false

	r._ring.DequeueFunc(func(c *_chunk) {
		if c._size == 0 && r._ignore_nil {
			nodata = true
			return
		}

		addr := c._pointer + r._head
		b := unsafe.Slice((*byte)(unsafe.Pointer(addr)), int(c._size))
		data(b)
	})

	if nodata {
		goto retry
	}
}
