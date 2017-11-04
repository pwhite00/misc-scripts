package main

import (
	"flag"
	"fmt"
	"os"
	"runtime"
	"time"
)

// profile current system resources.

type DataReturn struct {
	Hostname string `json:"device"`
	Uptime   int64  `json:"update"`
	Os       string `json:"operatingSystemFamily,omitempty"`
	Role     string `json:"deviceRole,omitempty"`
	//SerialNumber string `json:"systemId,omitEmpty"`
}

type DiskReturn struct {
	DiskParitionName string `json:"diskPartitionName,omitempty"`
	//DiskPartitionData map["string"]float64 `json:"omitempty"`

}

type LoadReturn struct {
	SystemLoadUsage1Min  int `json:"load1,omitempty"`
	SystemLoadUsage5Min  int `json:"load5,omitempty"`
	SystemLoadUsage10Min int `json:"load10,omitempty"`
}

type CpuReturn struct {
	CpuProcessUsage string `json:"cpuProcessUsage,omitempty"`
	CpuSystemUsage  string `json:"cpuSystemUsage,omitempty"`
}

type MemoryReturn struct {
	MemoryProcessUsage string `json:"memoryProcessUsage,omitempty"`
	MemorySystemUsage  string `json:"memorySystemUsage,omitempty"`
}

var Results = make(map[string]interface{})
var myVersion = "Version: 0.1.1"

func main() {
	allFlag := flag.Bool("a", "false", "Run all checks.")
	memFlag := flag.Bool("m", "false", "Profile system memory usage.[OPTIONAL: use -pid PID to look at a specific process.")
	cpuFlag := flag.Bool("c", "false", "Profile system cpu usage. [OPTIONAL: use -pid PID to look at a spcecific process.")
	loadFlag := flag.Bool("l", "false", "Profile current system load.")
	diskSpaceFlag := flag.Bool("d", "false", "Profile current system Disk space.[OPTIONAL: Use --partition to specify a disk partition.]")
	pidFlag := flag.Int("pid", 0, "Defne a PID to run checks against.")
	partitionFlag := flag.String("mount", "empty", "Define a disk mount partition to run checks against.")
	versionFlag := flag.Bool("version", false, myVersion)
	flag.Parse()

	var CollectedResults DataReturn
	CollectedResults.Uptime = time.Now().Unix()
	CollectedResults.Hostname, _ = os.Hostname()

	// discover OS to figure how to run checks. or abort if not supported OS.
	Os := runtime.GOOS
	var OsSupported bool
	switch Os {
	case "darwin":
		OsSupported = false
	case "linux":
		OsSupported = true
	case "windows":
		OsSupported = false
	}

	if OsSupported != true {
		fmt.Printf("%s is not a supported os. Exiting.")
		os.Exit(1)
	}

	//modes:
	allChkOn := *allFlag
	memChkOn := *memFlag
	cpuChkOn := *cpuFlag
	loadChkOn := *loadFlag
	diskSpaceChkOk := *diskSpaceFlag
	pidValue := *pidFlag
	partitionValue := *partitionFlag

	if allChkOn {
		// run all checks
		if pidValue != 0 {
			// run pid based memory and cpu checks.
			Results["memProcUsage"] = memProcessChk(pidValue)
			Results["cpuProcUsage"] = cpuProcessChk(pidValue)
		} else {
			// run general memory and cou tests.
			Results["memSysUsage"] = memSystemChk()
			Results["cpuSysUsage"] = cpuSystemChk()
		}
		Results["systemLoad"] = systemLoadChk()
		if partitionValue != "empty" {
			// run specificed partition check.
			Results["diskPartChk"] = diskPartitionChk(partitionValue)
		} else {
			// run genersl disk paritition check.
			Results["diskPartsChk"] = diskSpaceChk()
		}
	}

	if memChkOn {
		// run memchk
		if pidValue != 0 {
			// run memory check on pid.
			Results["memProcUsage"] = memProcessChk(pidValue)
		} else {
			// run memory check on everything.
			Results["memSysUsage"] = memSystemChk()
		}
	}

	if cpuChkOn {
		// run cpu check
		if pidValue != 0 {
			// run cpu check on PID
			Results["cpuProcUsage"] = cpuProcessChk(pidValue)
		} else {
			// run cpu checks on everything.
			Results["cpuSysUsage"] = cpuSystemChk()
		}
	}

	if loadChkOn {
		// run load check
		Results["systemLoad1Min"], Results["systemLoad5Min"], Results["systemLoad5Min"] = systemLoadChk()
	}

	if diskSpaceChkOk {
		// run disk space check
		if partitionValue != "empty" {
			// run check on only specified disk partition.
			Results["diskPartChk"] = diskPartitionChk(partitionValue)
		} else {
			// run disk partition checks on all mounted partition.
			Results["diskPartsChk"] = diskSpaceChk()
		}
	}

	// publich Results.
	fmt.Printf("\n")
}
