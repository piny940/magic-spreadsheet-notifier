package config

import (
	"fmt"

	log "github.com/sirupsen/logrus"

	"github.com/joho/godotenv"
)

func Init(env string) {
	if env != "production" {
		if err := godotenv.Load(fmt.Sprintf(".env.%s", env)); err != nil {
			log.Fatal(err)
		}
	}
}
