package main

import (
	"context"
	"flag"
	"magic-spreadsheet-notification/config"
	"magic-spreadsheet-notification/db"
)

func main() {
	ctx := context.Background()
	env := flag.String("e", "development", "set environment")
	flag.Parse()

	config.Init(*env)

	db.Init(ctx)
}
