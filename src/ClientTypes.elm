module ClientTypes exposing (..)


type Msg
    = Interact String


type alias StorySnippet =
    { interactableName : String
    , interactableCssSelector : String
    , narrative : String
    }
