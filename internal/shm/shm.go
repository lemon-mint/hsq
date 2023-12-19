package shm

type SharedMemory struct {
	name string
	size int
	fd   uintptr
}

func (s *SharedMemory) Name() string {
	return s.name
}

func (s *SharedMemory) Size() int {
	return s.size
}

func (s *SharedMemory) FD() uintptr {
	return s.fd
}
