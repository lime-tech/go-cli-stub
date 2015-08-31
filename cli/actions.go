package cli

import (
	log "github.com/Sirupsen/logrus"
	"github.com/codegangsta/cli"
	"golang-cli-stub/config"
)

func dummyAction(c *cli.Context) {
	_, err := config.FromFile(c.String("config"))
	if err != nil {
		panic(err)
	}

	log.Info("Hello boilerplate")
}
