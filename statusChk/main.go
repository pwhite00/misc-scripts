package main

import (
	"flag"
	"fmt"
	"runtime"
	"os"
)

// profile current system resources.


type DataReturn struct{

}



import (
	"flag"
	"fmt"
)

var Results = make(map[string]interface{})


func main() {
	allFlag := flag.Bool("a", "false", "Run all checks.")
	memFlag := flag.Bool("m", "false", "Profile system memory usage.[OPTIONAL: use -pid PID to look at a specific process.")
	cpuFlag := flag.Bool("c", "false", "Profile system cpu usage. [OPTIONAL: use -pid PID to look at a spcecific process.")
	loadFlag := flag.Bool("l", "false", "Profile current system load.")
	diskSpaceFlag:= flag.Bool("d", "false", "Profile current system Disk space.[OPTIONAL: Use --partition to specify a disk partition.]")
	pidFlag := flag.Int("pid", 0, "Defne a PID to run checks against." )
	partitionFlag := flag.String("mount", "empty", "Define a disk mount partition to run checks against.")
	flag.Parse()

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
		Results["systemLoad"] = loadChk()
		if partitionValue != "empty" {
			// run specificed partition check.
			results["diskPartChk"] = diskPartitionChk(partitionValue)
		} else {
			// run genersl disk paritition check.
			 results["diskPartsChk"] = diskSpaceChk()
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
		Results["systemLoad"] = systemLoadChk()
	}

	if diskSpaceChkOk {
		// run disk space check
		if partitionValue != "empty" {
			// run check on only specified disk partition.
			results["diskPartChk"] = diskPartitionChk(partitionValue)
		} else {
			// run disk partition checks on all mounted partition.
			results["diskPartsChk"] = diskSpaceChk()
		}
	}

	// publich results.
  fmt.Printf("\n")
}
