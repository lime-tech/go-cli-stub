package cli

import (
	"github.com/codegangsta/cli"
)

var (
	rootFlags = []cli.Flag{
		cli.BoolFlag{
			Name:   "debug",
			Usage:  "debug mode",
			EnvVar: "DEBUG",
		},
		cli.StringFlag{
			Name:  "log-level, l",
			Value: "info",
			Usage: "log level(debug, info, warn, error, fatal, panic)",
		},
	}
	dummyFlags = []cli.Flag{
		cli.StringFlag{
			Name:  "config",
			Value: "config.toml",
			Usage: "path to configuration file in TOML firmat",
		},
	}
)
