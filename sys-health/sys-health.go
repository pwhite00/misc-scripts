package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	fmt.Println("Collecting facts for printing.")
	fmt.Println(os.Getenv("USER"))
	fmt.Println(os.Hostname())

}
