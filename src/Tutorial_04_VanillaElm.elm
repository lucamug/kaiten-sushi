module Tutorial_04_VanillaElm exposing (main)

import Browser
import Browser.Events
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time


title =
    "04 - VANILLA ELM - CLICK ANYWHERE"


view model =
    [ img [ id "kaiten", src "https://lucamug.github.io/kaiten-sushi/svg/background.svg", onClick ClickOnPage ] []
    , div [ id "homeLink" ]
        [ a [ href "https://lucamug.github.io/kaiten-sushi/" ]
            [ img [ src "https://lucamug.github.io/kaiten-sushi/svg/home.svg" ] [] ]
        ]
    , div [ id "title" ] [ text title ]
    , div ([ id "sushi" ] ++ changeStyle model.currentState) [ text "🍣" ]
    ]


changeStyle { scale, x } =
    [ style "transform" ("scale(" ++ String.fromFloat scale ++ ")")
    , style "left" (String.fromFloat x ++ "px")
    ]


onTheKaiten =
    { x = 50
    , scale = 1
    }


inTheKitchen =
    { x = 600
    , scale = 0
    }


init =
    { currentState = onTheKaiten
    , animationStart = onTheKaiten
    , target = onTheKaiten
    , animationLength = 0
    , progress = Nothing
    }


clickOnPage model =
    if model.target == onTheKaiten then
        { model
            | target = inTheKitchen
            , animationStart = model.currentState
            , animationLength = 1000
            , progress = Just 0
        }

    else
        { model
            | target = onTheKaiten
            , animationStart = model.currentState
            , animationLength = 1000
            , progress = Just 0
        }


animationFrame model delta =
    case model.progress of
        Just progress ->
            if progress < model.animationLength then
                let
                    animationRatio =
                        Basics.min 1 (progress / model.animationLength)

                    newX =
                        model.animationStart.x
                            + (model.target.x - model.animationStart.x)
                            * animationRatio

                    newScale =
                        model.animationStart.scale
                            + (model.target.scale - model.animationStart.scale)
                            * animationRatio
                in
                { model
                    | progress = Just <| progress + delta
                    , currentState = { x = newX, scale = newScale }
                }

            else
                { model
                    | progress = Nothing
                    , currentState = model.target
                }

        Nothing ->
            model


subscriptions model =
    case model.progress of
        Just _ ->
            Browser.Events.onAnimationFrameDelta AnimationFrame

        Nothing ->
            Sub.none


update msg model =
    case msg of
        ClickOnPage ->
            clickOnPage model

        AnimationFrame delta ->
            animationFrame model delta


type Msg
    = AnimationFrame Float
    | ClickOnPage


type alias State =
    { scale : Float, x : Float }


type alias Model =
    { currentState : State
    , target : State
    , animationLength : Float
    , progress : Maybe Float
    , animationStart : State
    }


sandboxWithTitleAndSubscriptions args =
    Browser.document
        { init = \_ -> ( args.init, Cmd.none )
        , view = \model -> { title = args.title, body = args.view model }
        , update = \msg model -> ( args.update msg model, Cmd.none )
        , subscriptions = args.subscriptions
        }


main : Program () Model Msg
main =
    sandboxWithTitleAndSubscriptions
        { title = title
        , init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
