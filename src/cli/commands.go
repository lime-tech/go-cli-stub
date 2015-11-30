package cli

import (
	"github.com/codegangsta/cli"
)

var (
	commands = []cli.Command{
		{
			Name:      "dummy",
			ShortName: "d",
			Usage:     "Not so useful",
			Flags:     dummyFlags,
			Action:    dummyAction,
		},
	}
)
