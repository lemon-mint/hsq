package common

import "os"

const (
	SharedMemoryName          = "/tunnel05"
	SharedMemoryQueueLength   = 128
	SharedMemoryReceiverFlags = os.O_RDWR | os.O_CREATE
	SharedMemorySenderFlags   = os.O_RDWR
	SharedMemoryMode          = 0600
)

const (
	MPMCChunkSize = 4096
)
