module Tutorial_06_ElmAnimatorInline2 exposing (main)

import Animator
import Animator.Inline
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time


title =
    "06 - ELM ANIMATOR INLINE 2 - CLICK ANYWHERE"


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
        (\state_ -> Animator.at state_.x)
    , scaleXY
        state
        (\state_ ->
            { x = Animator.at state_.scaleX
            , y = Animator.at state_.scaleY
            }
        )
    ]


onTheKaiten =
    { x = 50
    , scaleX = 1
    , scaleY = 1
    }


toTheKitchen20 =
    { x = 100
    , scaleX = 0.8
    , scaleY = 1.2
    }


toTheKitchen40 =
    { x = 20
    , scaleX = 1.2
    , scaleY = 0.8
    }


inTheKitchen =
    { x = 600
    , scaleX = 0
    , scaleY = 0
    }


init =
    { currentState = Animator.init onTheKaiten
    , direction = ToTheKitchen
    }


animator =
    Animator.watchingWith
        .currentState
        (\newChecked model -> { model | currentState = newChecked })
        (\_ -> False)
        Animator.animator


update msg model =
    case msg of
        AnimationFrame newTime ->
            model
                |> Animator.update newTime animator

        ClickOnPage ->
            { model
                | currentState =
                    Animator.queue
                        (case model.direction of
                            ToTheKaiten ->
                                [ Animator.event (Animator.seconds 0.6) toTheKitchen40
                                , Animator.event (Animator.seconds 0.6) toTheKitchen20
                                , Animator.event (Animator.seconds 0.8) onTheKaiten
                                ]

                            ToTheKitchen ->
                                [ Animator.event (Animator.seconds 0.6) toTheKitchen20
                                , Animator.event (Animator.seconds 0.6) toTheKitchen40
                                , Animator.event (Animator.seconds 0.8) inTheKitchen
                                ]
                        )
                        model.currentState
                , direction =
                    case model.direction of
                        ToTheKaiten ->
                            ToTheKitchen

                        ToTheKitchen ->
                            ToTheKaiten
            }


toggleState state =
    if state == onTheKaiten then
        inTheKitchen

    else
        onTheKaiten


subscriptions model =
    animator
        |> Animator.toSubscription AnimationFrame model


type Msg
    = AnimationFrame Time.Posix
    | ClickOnPage


type Direction
    = ToTheKitchen
    | ToTheKaiten


type alias State =
    { scaleX : Float, scaleY : Float, x : Float }


type alias Model =
    { currentState : Animator.Timeline State
    , direction : Direction
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


scaleXY : Animator.Timeline state -> (state -> { x : Animator.Movement, y : Animator.Movement }) -> Html.Attribute msg
scaleXY timeline lookup =
    let
        pos =
            Animator.xy timeline lookup
    in
    Html.Attributes.style "transform"
        ("scaleX(" ++ String.fromFloat pos.x ++ ") scaleY(" ++ String.fromFloat pos.y ++ ")")
