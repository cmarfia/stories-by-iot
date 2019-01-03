module Story.AllStories exposing (allStories)

import Story.Components exposing (..)
import Story.HowJaraldandTenzinMet.StoryInfo as StoryOne
import Story.TheAdventuresOfLaz.StoryInfo as StoryTwo


allStories : List StoryInfo
allStories =
    [ StoryOne.storyInfo
    , StoryTwo.storyInfo
    ]
