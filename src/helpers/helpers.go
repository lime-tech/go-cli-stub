package helpers

import (
	"bytes"
	"encoding/gob"
	log "github.com/Sirupsen/logrus"
	"os"
	"reflect"
	"runtime"
)

func Homepath() string {
	if runtime.GOOS == "windows" {
		return os.Getenv("USERPROFILE")
	} else {
		return os.Getenv("HOME")
	}
}

func Unpanic(onRecover func(interface{})) {
	if err := recover(); err != nil {
		trace := make([]byte, 4096)
		count := runtime.Stack(trace, true)

		log.Printf("Recovered from panic: %v\nStack has %d bytes ->\n%s\n", err, count, trace)

		if onRecover != nil {
			onRecover(err)
		}
	}
}
