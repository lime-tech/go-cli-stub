package cli

import (
	log "github.com/Sirupsen/logrus"
	"github.com/codegangsta/cli"
	"go-cli-stub/src/config"
	"os"
)

func dummyAction(c *cli.Context) {
	_, err := config.FromFile(c.String("config"))
	if err != nil {
		log.Error(err)
		defer os.Exit(1)
		return
	}

	log.Info("Hello boilerplate")
}
