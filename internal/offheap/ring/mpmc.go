package ring

import (
	"context"
	"runtime"
	"sync/atomic"
	"time"
	"unsafe"
)

type MPMCRing[T any] struct {
	_mask uint64
	_size uint64
	_head uintptr
	_data uintptr
}

func MPMCInit[T any](h uintptr, size uint64) bool {
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
			_e := (*_melem[T])(unsafe.Pointer(_data + unsafe.Sizeof(_melem[T]{})*uintptr(i)))
			_e._data = *new(T)
			_e._seq = i
		}

		atomic.StoreUint64(&_r.r, 0)
		atomic.StoreUint64(&_r.w, 0)
		atomic.StoreUint64(&_r._flag, uint64(_mpmc_init))

		return true
	}
	return false
}

func MPMCAttach[T any](h uintptr, timeout time.Duration) *MPMCRing[T] {
	_tt := time.Now()
	_r := (*_mring)(unsafe.Pointer(h))
	for {
		magic := atomic.LoadUint64(&_r._magic)
		flag := atomic.LoadUint64(&_r._flag)
		size := atomic.LoadUint64(&_r._size)
		if magic == _mpmc_magic && flag&uint64(_mpmc_init) != 0 {
			return &MPMCRing[T]{
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

func (m *MPMCRing[T]) EnqueueWithContext(ctx context.Context, elem T) bool {
	done := ctx.Done()
	_h := (*_mring)(unsafe.Pointer(m._head))

	var c *_melem[T]
	p := atomic.LoadUint64(&_h.w)
	for {
		select {
		case <-done:
			return false
		default:
		}

		c = (*_melem[T])(unsafe.Pointer(m._data + unsafe.Sizeof(_melem[T]{})*uintptr(p&m._mask)))
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

	c._data = elem
	atomic.StoreUint64(&c._seq, p+1)
	return true
}

func (m *MPMCRing[T]) Enqueue(elem T) {
	_h := (*_mring)(unsafe.Pointer(m._head))

	var c *_melem[T]
	p := atomic.LoadUint64(&_h.w)
	for {
		c = (*_melem[T])(unsafe.Pointer(m._data + unsafe.Sizeof(_melem[T]{})*uintptr(p&m._mask)))
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

	c._data = elem
	atomic.StoreUint64(&c._seq, p+1)
}

func (m *MPMCRing[T]) EnqueueFunc(fn func(*T)) {
	_h := (*_mring)(unsafe.Pointer(m._head))

	var c *_melem[T]
	p := atomic.LoadUint64(&_h.w)
	for {
		c = (*_melem[T])(unsafe.Pointer(m._data + unsafe.Sizeof(_melem[T]{})*uintptr(p&m._mask)))
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

	fn(&c._data)
	atomic.StoreUint64(&c._seq, p+1)
}

func (m *MPMCRing[T]) DequeueWithContext(ctx context.Context) (elem T, ok bool) {
	done := ctx.Done()
	_h := (*_mring)(unsafe.Pointer(m._head))

	var c *_melem[T]
	p := atomic.LoadUint64(&_h.r)
	for {
		select {
		case <-done:
			ok = false
			return
		default:
		}

		c = (*_melem[T])(unsafe.Pointer(m._data + unsafe.Sizeof(_melem[T]{})*uintptr(p&m._mask)))
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

	elem = c._data
	ok = true
	atomic.StoreUint64(&c._seq, p+m._mask+1)
	return
}

func (m *MPMCRing[T]) Dequeue() (elem T) {
	_h := (*_mring)(unsafe.Pointer(m._head))

	var c *_melem[T]
	p := atomic.LoadUint64(&_h.r)
	for {
		c = (*_melem[T])(unsafe.Pointer(m._data + unsafe.Sizeof(_melem[T]{})*uintptr(p&m._mask)))
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

	elem = c._data
	atomic.StoreUint64(&c._seq, p+m._mask+1)
	return
}

func (m *MPMCRing[T]) DequeueFunc(fn func(*T)) {
	_h := (*_mring)(unsafe.Pointer(m._head))

	var c *_melem[T]
	p := atomic.LoadUint64(&_h.r)
	for {
		c = (*_melem[T])(unsafe.Pointer(m._data + unsafe.Sizeof(_melem[T]{})*uintptr(p&m._mask)))
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

	fn(&c._data)
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

type _melem[T any] struct {
	_data T

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

func SizeMPMCRing[T any](len uintptr) uintptr {
	return 256 + unsafe.Sizeof(_mring{}) + unsafe.Sizeof(_melem[T]{})*len
}
