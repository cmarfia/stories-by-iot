package template

import (
	"errors"
	"html/template"
	"io"

	"github.com/labstack/echo"
)

type renderer struct {
	templates *template.Template
}

// Render renders a template document
func (t *renderer) Render(w io.Writer, name string, data interface{}, c echo.Context) error {
	return t.templates.ExecuteTemplate(w, name, data)
}

// Index ...
type Index struct {
	Title   string
	Version int
}

// Init sets the template renderer for the echo framework
func Init(e *echo.Echo) error {
	t, err := template.New("index").Parse(`
		<!DOCTYPE html>
		<html lang="en-us">
		<head>
			<meta charSet="utf-8" />
			<meta name="viewport" content="width=device-width, initial-scale=1" />
			<link rel="shortcut icon" href="/img/fav.ico" type="image/x-icon">
			<title>{{.Title}}</title>
			<link href="/css/reset.css?v={{.Version}}" rel="stylesheet" type="text/css" />
			<link href="/css/main.css?v={{.Version}}" rel="stylesheet" type="text/css" />
			<link href="/css/github-markdown.css?v={{.Version}}" rel="stylesheet" type="text/css" />
			<link href="/css/skeleton.css?v={{.Version}}" rel="stylesheet" type="text/css" />
			<link href="/css/handdrawn.css?v={{.Version}}" rel="stylesheet" type="text/css" />
		</head>
		<body>
			<main></main>
			<script src="/js/marked.min.js?v={{.Version}}"></script>
			<script src="/js/elm.js?v={{.Version}}"></script>
  			<script src="https://sdk.amazonaws.com/js/aws-sdk-2.283.1.min.js"></script>
			<script src="/js/index.js?v={{.Version}}"></script>
		</body>
		</html>
	`)
	if err != nil {
		return err
	}

	if t == nil {
		return errors.New("template: error creating template, template is nil")
	}

	e.Renderer = &renderer{t}
	return nil
}
