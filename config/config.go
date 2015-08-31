package config

import (
	"encoding/json"
	"github.com/BurntSushi/toml"
	log "github.com/Sirupsen/logrus"
)

type Config struct{}

func FromFile(path string) (*Config, error) {
	config := new(Config)

	if _, err := toml.DecodeFile(path, &config); err != nil {
		return nil, err
	}

	prettyConfig, err := json.MarshalIndent(config, "", "    ")
	if err != nil {
		return nil, err
	}

	log.WithFields(log.Fields{
		"config": prettyConfig,
	}).Debug("Loaded config")

	return config, nil
}
