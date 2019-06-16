// Package main is responsible for initializing and running the application
package main

import (
	"log"

	"github.com/cmarfia/stories-by-iot/internal/routes"
	"github.com/cmarfia/stories-by-iot/internal/server"
	"github.com/cmarfia/stories-by-iot/internal/dynamodb"
)

func main() {
    defer func() {
        if r := recover(); r != nil {
            log.Println("Recovered from ", r)
        }
	}()

	dynamoService := dynamodb.MustInitialize()

	e, err := server.New(&dynamoService)
	if err != nil {
		log.Fatal(err)
	}

	routes.Register(e)

	e.Logger.Fatal(e.Start(":8080"))
}
