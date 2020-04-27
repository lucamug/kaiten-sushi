module Tutorial_05_ElmAnimatorInline1 exposing (main)

import Animator
import Animator.Inline
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time


title =
    "05 - ELM ANIMATOR INLINE - CLICK ANYWHERE"


view model =
    [ img [ id "kaiten", src "https://lucamug.github.io/kaiten-sushi/svg/background.svg", onClick ClickOnPage ] []
    , div [ id "homeLink" ]
        [ a [ href "https://lucamug.github.io/kaiten-sushi/" ]
            [ img [ src "https://lucamug.github.io/kaiten-sushi/svg/home.svg" ] [] ]
        ]
    , div [ id "title" ] [ text title ]
    , div ([ id "sushi" ] ++ changeStyle model.currentState) [ text "🍣" ]
    ]


changeStyle state =
    [ Animator.Inline.style
        state
        "left"
        (\float -> String.fromFloat float ++ "px")
        (\state_ ->
            if state_ == inTheKitchen then
                Animator.at inTheKitchen.x

            else
                Animator.at onTheKaiten.x
        )
    , Animator.Inline.scale
        state
        (\state_ ->
            if state_ == inTheKitchen then
                Animator.at inTheKitchen.scale

            else
                Animator.at onTheKaiten.scale
        )
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
    { currentState = Animator.init onTheKaiten }


animator =
    Animator.watchingWith
        .currentState
        (\newChecked model -> { model | currentState = newChecked })
        (\_ -> False)
        Animator.animator


clickOnPage model =
    if Animator.current model.currentState == onTheKaiten then
        { model
            | currentState =
                Animator.go
                    (Animator.seconds 1)
                    inTheKitchen
                    model.currentState
        }

    else
        { model
            | currentState =
                Animator.go
                    (Animator.seconds 1)
                    onTheKaiten
                    model.currentState
        }


animationFrame model time =
    Animator.update time animator model


subscriptions model =
    animator
        |> Animator.toSubscription AnimationFrame model


update msg model =
    case msg of
        ClickOnPage ->
            clickOnPage model

        AnimationFrame time ->
            animationFrame model time


type Msg
    = AnimationFrame Time.Posix
    | ClickOnPage


type alias State =
    { scale : Float, x : Float }


type alias Model =
    { currentState : Animator.Timeline State
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
