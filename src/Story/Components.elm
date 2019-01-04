module Story.Components exposing
    ( Component(..)
    , Components
    , Entity
    , Manifest
    , Snippet
    , SpeakingPosition(..)
    , StoryInfo
    , addClassName
    , addComponent
    , addImage
    , addName
    , addNarrative
    , addRuleData
    , addSpeakingPosition
    , createRule
    , entity
    , findEntity
    , getClassName
    , getImage
    , getName
    , getNarrative
    , getRuleData
    , getSpeakingPosition
    )

import Dict exposing (..)
import Engine


type alias Manifest =
    { items : List Entity
    , characters : List Entity
    , locations : List Entity
    }


type alias StoryInfo =
    { title : String
    , slug : String
    , cover : String
    , manifest : Manifest
    , startingNarrative : Snippet
    , startingState : List Engine.ChangeWorldCommand
    , rules : Dict String Components
    , imagesToPreLoad : List String
    }


type alias Snippet =
    { interactableName : String
    , interactableCssSelector : String
    , narrative : String
    }


{-| An entity is simply an id associated with some potential components and their data.
Each object in your story is an entity - this includes items, locations, and characters, but also rules too.
-}
type alias Entity =
    ( String, Components )


type alias Components =
    Dict String Component


type Component
    = Name String
    | Image String
    | SpeakingPosition SpeakingPosition
    | ClassName String
    | Narrative String
    | RuleData Engine.Rule


type SpeakingPosition
    = Left
    | Right


entity : String -> Entity
entity id =
    ( id, Dict.empty )


addComponent : String -> Component -> Entity -> Entity
addComponent componentId component ( id, components ) =
    ( id, Dict.insert componentId component components )


addName : String -> Entity -> Entity
addName name =
    addComponent "name" <| Name name


getName : Entity -> String
getName ( id, components ) =
    case Dict.get "name" components of
        Just (Name name) ->
            name

        _ ->
            id


addImage : String -> Entity -> Entity
addImage url =
    addComponent "image" <| Image url


getImage : Entity -> Maybe String
getImage ( id, components ) =
    case Dict.get "image" components of
        Just (Image url) ->
            Just url

        _ ->
            Nothing


addSpeakingPosition : SpeakingPosition -> Entity -> Entity
addSpeakingPosition speakingPosition =
    addComponent "position" <| SpeakingPosition speakingPosition


getSpeakingPosition : Entity -> SpeakingPosition
getSpeakingPosition ( id, components ) =
    case Dict.get "position" components of
        Just (SpeakingPosition speakingPosition) ->
            speakingPosition

        _ ->
            Right


addClassName : String -> Entity -> Entity
addClassName className =
    addComponent "classname" <| ClassName className


getClassName : Entity -> String
getClassName ( id, components ) =
    case Dict.get "classname" components of
        Just (ClassName className) ->
            className

        _ ->
            ""


addNarrative : String -> Entity -> Entity
addNarrative narrative =
    addComponent "narrative" <| Narrative narrative


getNarrative : String -> Components -> String
getNarrative id components =
    case Dict.get "narrative" components of
        Just (Narrative narrative) ->
            narrative

        _ ->
            id


addRuleData : Engine.Rule -> Entity -> Entity
addRuleData ruleData =
    addComponent "ruleData" <| RuleData ruleData


getRuleData : String -> Components -> Engine.Rule
getRuleData id components =
    case Dict.get "ruleData" components of
        Just (RuleData rule) ->
            rule

        _ ->
            { interaction = Engine.with ""
            , conditions = []
            , changes = []
            }


createRule : String -> Engine.Rule -> String -> Entity
createRule id ruleData narrative =
    entity id
        |> addRuleData ruleData
        |> addNarrative narrative


findEntity : Manifest -> String -> Entity
findEntity manifest id =
    (manifest.items ++ manifest.locations ++ manifest.characters)
        |> List.filter (Tuple.first >> (==) id)
        |> List.head
        |> Maybe.withDefault (entity id)
