module Story.AllStories exposing (allStories)

import Story.Components exposing (..)
import Story.TheAdventuresOfLaz01.StoryInfo as StoryOne



{-
   TODO
    Add new stories to this list to render them in the application.

   Note
    Each story will need a rule called TheEnd which will signal the
    application to trigger the end story action.
-}


allStories : List StoryInfo
allStories =
    [ StoryOne.storyInfo
    ]
