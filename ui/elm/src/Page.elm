module Page exposing (Page(..))

import Page.Home as Home
import Page.NotFound as NotFound
import Page.Story as Story

type Page
    = NotFound NotFound.Model
    | Home Home.Model
    | Story Story.Model