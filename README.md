# Stories By Iot

[StoriesByIot.com](http://www.storiesbyiot.com)

This is a collection of stories created by my son. These interative stories are using the [Elm Narrative Engine](http://package.elm-lang.org/packages/jschomay/elm-narrative-engine/latest).

## Getting Started

```bash
# Install elm, elm-format, elm-live, and http-server
npm i -g elm@0.19.0-bugfix2 elm-format@0.8.1 elm-live@3.4.0 http-server@0.11.1

# Clone the repo
git clone git@github.com:cmarfia/My-Children-Stories.git

# Navigate into the clone repo
cd My-Children-Stories

# Install NPM dependencies
npm i

# Run the application in development mode
npm run start
```

## Deployment

```bash
# Build the production files
npm run build

# Validate the build is working
npm run serve-build
```

Push all the files in the dist foldr to the `gh-pages` branch.

## Add a Story

1. Add a folder to `/src/Story/{New Story Name}`
2. Create a file called `StoryInfo.elm` in the new folder
3. Add the exported `StoryInfo` to the `allStories` list in `/src/Story/AllStories.elm`
4. Build out your new story using the exising stories as a guide