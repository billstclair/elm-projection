module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Projection exposing (project)
import Projection.Types exposing (Eye, Number, Point, Shape)
import Projection.Util as Util


theEye : Eye
theEye =
    { position = [ 0, 10, 0 ]
    , direction = [ 0, 0, 0 ]
    , up = [ 0, 0, 1 ]
    }


e : Number
e =
    1 / 2


cube : Shape
cube =
    [ [ -e, -e, -e ]
    , [ -e, e, -e ]
    , [ -e, e, e ]
    , [ -e, -e, e ]
    , [ -e, -e, -e ]

    --face 2
    , [ e, -e, -e ]
    , [ e, e, -e ]
    , [ -e, e, -e ]
    , [ -e, -e, -e ]

    --face 3
    , [ -e, -e, e ]
    , [ -e, e, e ]
    , [ -e, e, -e ]
    , [ -e, -e, -e ]

    --new base
    , [ e, -e, -e ]

    -- face 4
    , [ e, e, -e ]
    , [ e, e, e ]
    , [ e, -e, e ]
    , [ e, -e, -e ]

    -- face 5
    , [ -e, -e, -e ]
    , [ -e, e, -e ]
    , [ e, e, -e ]
    , [ e, -e, -e ]

    -- face 6
    , [ e, e, -e ]
    , [ e, e, e ]
    , [ e, -e, e ]
    , [ e, -e, -e ]
    ]


projectTo2 : Point -> Eye -> ( Point, Eye )
projectTo2 point eye =
    if Util.pointDimension point <= 2 then
        ( point, eye )

    else
        let
            ( p2, e2 ) =
                Projection.project point eye
        in
        projectTo2 p2 e2


type alias Model =
    { count : Int }


initialModel : Model
initialModel =
    { count = 0 }


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }


h1 : String -> Html msg
h1 s =
    Html.h1 [] [ Html.text s ]


view : Model -> Html Msg
view model =
    div []
        [ h1 "billstclair/elm-projection example"
        , div []
            [ text "This will become an "
            , Html.code [] [ text "elm-projection" ]
            , text " example."
            ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
