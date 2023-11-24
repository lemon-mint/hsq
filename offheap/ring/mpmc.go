package ring

import (
	"runtime"
	"sync/atomic"
	"time"
	"unsafe"
)

type MPMCRing struct {
	_mask uint64
	_size uint64
	_head uintptr
	_data uintptr
}

func MPMCInit(h uintptr, size uint64) bool {
	size = _RoundUpPowerOf2(size)
	_r := (*_mring)(unsafe.Pointer(h))
	magic := atomic.LoadUint64(&_r._magic)
	if magic == _mpmc_magic {
		return false
	}

	if atomic.CompareAndSwapUint64(&_r._magic, magic, _mpmc_magic) {
		atomic.StoreUint64(&_r._size, size)
		//_head := h
		_data := h + 256
		for i := uint64(0); i < size; i++ {
			atomic.StoreUintptr((*uintptr)(unsafe.Pointer(_data+uintptr(16*i))), 0)
			atomic.StoreUint64((*uint64)(unsafe.Pointer(_data+uintptr(16*i+8))), i)
		}

		atomic.StoreUint64(&_r.r, 0)
		atomic.StoreUint64(&_r.w, 0)
		atomic.StoreUint64(&_r._flag, uint64(_mpmc_init))

		return true
	}
	return false
}

func MPMCAttach(h uintptr, timeout time.Duration) *MPMCRing {
	_tt := time.Now()
	_r := (*_mring)(unsafe.Pointer(h))
	for {
		magic := atomic.LoadUint64(&_r._magic)
		flag := atomic.LoadUint64(&_r._flag)
		size := atomic.LoadUint64(&_r._size)
		if magic == _mpmc_magic && flag&uint64(_mpmc_init) != 0 {
			return &MPMCRing{
				_size: size,
				_mask: size - 1,
				_head: h,
				_data: h + 256,
			}
		}

		if timeout <= 0 && time.Since(_tt) >= timeout {
			return nil
		}
		runtime.Gosched()
	}
}

func (m *MPMCRing) Enqueue(ptr uintptr) {
	_h := (*_mring)(unsafe.Pointer(m._head))

	var c *_melem
	p := atomic.LoadUint64(&_h.w)
	for {
		c = (*_melem)(unsafe.Pointer(m._data + uintptr(16*(p&m._mask))))
		seq := atomic.LoadUint64(&c._seq)
		diff := seq - p
		if diff == 0 {
			if atomic.CompareAndSwapUint64(&_h.w, p, p+1) {
				break
			}
		} else if diff > 0 {
			p = atomic.LoadUint64(&_h.w)
		} else {
			panic("unreachable")
		}

		runtime.Gosched()
	}

	c.ptr = ptr
	atomic.StoreUint64(&c._seq, p+1)
}

func (m *MPMCRing) Dequeue() (ptr uintptr) {
	_h := (*_mring)(unsafe.Pointer(m._head))

	var c *_melem
	p := atomic.LoadUint64(&_h.r)
	for {
		c = (*_melem)(unsafe.Pointer(m._data + uintptr(16*(p&m._mask))))
		seq := atomic.LoadUint64(&c._seq)
		diff := seq - (p + 1)
		if diff == 0 {
			if atomic.CompareAndSwapUint64(&_h.r, p, p+1) {
				break
			}
		} else if diff > 0 {
			p = atomic.LoadUint64(&_h.r)
		} else {
			panic("unreachable")
		}
	}

	ptr = c.ptr
	atomic.StoreUint64(&c._seq, p+m._mask+1)
	return
}

const _mpmc_magic uint64 = 0x25f801fa0f08158b

type _mpmcflag uint64

const (
	_mpmc_reserved = _mpmcflag(1) << iota
	_mpmc_init
)

const _CACHE_LINE = 16 // 128 bits padding

type _mring struct {
	_magic uint64
	_size  uint64
	_flag  uint64
	/* ======== */
	r   uint64
	_p0 [_CACHE_LINE - 4]uint64
	w   uint64
	_p1 [_CACHE_LINE - 1]uint64
}

type _melem struct {
	ptr  uintptr
	_seq uint64
}

// https://graphics.stanford.edu/~seander/bithacks.html#RoundUpPowerOf2
func _RoundUpPowerOf2(v uint64) uint64 {
	v--
	v |= v >> 1
	v |= v >> 2
	v |= v >> 4
	v |= v >> 8
	v |= v >> 16
	v |= v >> 32
	v++
	return v
}
