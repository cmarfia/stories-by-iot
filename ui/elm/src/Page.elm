module Page exposing (Page(..))

import Page.Dashboard as Dashboard
import Page.EditStory as EditStory
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Story as Story


type Page
    = NotFound NotFound.Model
    | Home Home.Model
    | Story Story.Model
    | Dashboard Dashboard.Model
    | EditStory EditStory.Model
