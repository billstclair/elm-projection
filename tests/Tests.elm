module Tests exposing (all)

import Dict
import Expect exposing (Expectation)
import Json.Decode as JD exposing (Decoder)
import Json.Encode as JE exposing (Value)
import List
import Maybe exposing (withDefault)
import Projection.EncodeDecode as ED
import Projection.Types as Types
    exposing
        ( Eye
        , Number
        , Point
        , Room
        , Seer
        , Shape
        , Vector
        )
import Set exposing (Set)
import Test exposing (..)


testMap : (x -> String -> Test) -> List x -> List Test
testMap test data =
    let
        numbers =
            List.map String.fromInt <| List.range 1 (List.length data)
    in
    List.map2 test data numbers


all : Test
all =
    Test.concat <|
        List.concat
            [ testMap (convertTest "point" ED.encodePoint ED.pointDecoder) pointData
            , testMap (convertTest "vector" ED.encodeVector ED.vectorDecoder) vectorData
            , testMap (convertTest "shape" ED.encodeShape ED.shapeDecoder) shapeData
            , testMap (convertTest "room" ED.encodeRoom ED.roomDecoder) roomData
            , testMap (convertTest "eye" ED.encodeEye ED.eyeDecoder) eyeData
            , testMap (convertTest "seer" ED.encodeSeer ED.seerDecoder) seerData
            ]


convertTest : String -> (x -> Value) -> Decoder x -> (x -> String -> Test)
convertTest name encode decoder =
    let
        res x number =
            Test.test (name ++ number) (expectationer x)

        expectationer x () =
            expectResult (Ok x) <| JD.decodeValue decoder (encode x)
    in
    res


expectResult : Result JD.Error thing -> Result JD.Error thing -> Expectation
expectResult sb was =
    case was of
        Err msg ->
            case sb of
                Err _ ->
                    Expect.true "You shouldn't ever see this." True

                Ok _ ->
                    Expect.false (JD.errorToString msg) True

        Ok wasv ->
            case sb of
                Err _ ->
                    Expect.false "Expected an error but didn't get one." True

                Ok sbv ->
                    Expect.equal sbv wasv


pointData : List Point
pointData =
    [ [ 1, 2, 3, 4 ]
    , [ 5, 6 ]
    ]


vectorData : List Vector
vectorData =
    [ { from = [ 1, 2, 3 ]
      , to = [ 4, 5, 6 ]
      }
    ]


shapeData : List Shape
shapeData =
    [ [ [ 1, 2, 3, 4 ]
      , [ 5, 6, 7, 8 ]
      ]
    , [ [ 9, 10, 11, 12 ]
      , [ 13, 14, 15, 16 ]
      , [ 17, 18, 19, 20 ]
      ]
    ]


room : Room
room =
    shapeData


roomData : List Room
roomData =
    [ room
    , List.reverse room
    ]


eye : Eye
eye =
    { position = [ 1, 2, 3 ]
    , direction =
        { from = [ 4, 5, 6 ]
        , to = [ 7, 8, 9 ]
        }
    , up =
        { from = [ 10, 11, 12 ]
        , to = [ 13, 14, 15 ]
        }
    }


eyeData : List Eye
eyeData =
    [ eye
    ]


seerData : List Seer
seerData =
    [ { body = Maybe.withDefault [] <| List.head roomData
      , eye = eye
      }
    ]
