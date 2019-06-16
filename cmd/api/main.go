// Package main is responsible for initializing and running the application
package main

import (
	"log"

	"github.com/cmarfia/stories-by-iot/internal/routes"
	"github.com/cmarfia/stories-by-iot/internal/server"
)

func main() {
	e, err := server.New()
	if err != nil {
		log.Fatal(err)
	}

	routes.Register(e)

	e.Logger.Fatal(e.Start(":8080"))
}
