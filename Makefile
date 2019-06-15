clean:
	rm -rf dist

build-ui-prod:
	cp -R public/ dist/
	./node_modules/.bin/babel ui/js --out-dir dist/js
	elm make ui/elm/src/Main.elm --optimize --output=dist/js/elm.js

build-ui:
	cp -R public/ dist/
	./node_modules/.bin/babel ui/js --out-dir dist/js
	elm make ui/elm/src/Main.elm --output=dist/js/elm.js --debug

watch-ui: build-ui
	chokidar 'ui/**/*.elm' 'ui/**/*.js' -c 'make build-ui'

build-api:
	GOOS=darwin GOARCH=amd64 go build -o ./cmd/api/bin/api ./cmd/api/*.go

fmt-api:
	go fmt github.com/cmarfia/stories-by-iot/...

build: clean build-ui-prod
	make build-api

run: build
	./cmd/api/bin/api

install-global:
	npm i
	npm i -g elm elm-test elm-format chokidar-cli