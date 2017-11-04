package main

import ()

func memProcessChk(pid int) string {
// from /proc/pid/status vmSize
// from /proc/status memTotal
// (vmSize/ memTotal) * 100
	var memProcUsage string
	return memProcUsage
}

func memSystemChk() string {
	// from /proc/meminfo memtotal and memFree
	// ((memtotal - memfree)/ memtotal) * 100
	var memSysUsage string
	return memSysUsage
}
