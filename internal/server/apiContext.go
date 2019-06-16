package server 

import(
	"github.com/cmarfia/stories-by-iot/internal/dynamodb"

	"github.com/labstack/echo"
)

// APIContext represents the custom server context for the API
type APIContext struct {
	echo.Context
	DynamoService *dynamodb.Service
}
