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
import Projection.Util as Util
    exposing
        ( eyeDimension
        , isEyeValid
        , isRoomValid
        , isSeerValid
        , isShapeValid
        , isVectorValid
        , numberDimension
        , pointDimension
        , pointDistance
        , roomDimension
        , seerDimension
        , shapeDimension
        , vectorDimension
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
            , testMap (validTest "validVector" Util.isVectorValid) validVectorData
            , testMap (validTest "validShape" Util.isShapeValid) validShapeData
            , testMap (validTest "validRoom" Util.isRoomValid) validRoomData
            , testMap (validTest "validEye" Util.isEyeValid) validEyeData
            , testMap (validTest "validSeer" Util.isSeerValid) validSeerData
            , testMap (distanceTest "validDistance") validDistanceData
            ]


distanceTest : String -> (( Number, ( Point, Point ) ) -> String -> Test)
distanceTest name =
    let
        res ( expected, points ) number =
            Test.test (name ++ ": " ++ number) (expectationer points expected)

        expectationer ( p1, p2 ) expectedx () =
            expectValue expectedx <| Util.pointDistance p1 p2
    in
    res


validTest : String -> (x -> Bool) -> (( Bool, x ) -> String -> Test)
validTest name isValid =
    let
        res ( expected, x ) number =
            Test.test (name ++ ": " ++ number) (expectationer x expected)

        expectationer xx expectedx () =
            expectValue expectedx <| isValid xx
    in
    res


convertTest : String -> (x -> Value) -> Decoder x -> (x -> String -> Test)
convertTest name encode decoder =
    let
        res x number =
            Test.test (name ++ ": " ++ number) (expectationer x)

        expectationer x () =
            expectResult (Ok x) <| JD.decodeValue decoder (encode x)
    in
    res


expectValue : x -> x -> Expectation
expectValue sb was =
    Expect.true "should be the same" <| sb == was


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
    , direction = [ 4, 5, 6 ]
    , up = [ 0, 0, 1 ]
    }


eyeData : List Eye
eyeData =
    [ eye
    ]


seerData : List Seer
seerData =
    [ { body = room
      , eye = eye
      }
    ]


validVectorData : List ( Bool, Vector )
validVectorData =
    [ ( True, { from = [ 1, 2, 3 ], to = [ 4, 5, 6 ] } )
    , ( False, { from = [ 1, 2, 3 ], to = [ 4, 5 ] } )
    ]


validShapeData : List ( Bool, Shape )
validShapeData =
    [ ( True, [ [ 1, 2, 3 ], [ 4, 5, 6 ], [ 7, 8, 9 ] ] )
    , ( False, [ [ 1, 2 ], [ 3, 4, 5 ] ] )
    ]


validRoomData : List ( Bool, Room )
validRoomData =
    [ ( True, [ [ [ 1, 2 ], [ 3, 4 ] ], [ [ 5, 6 ], [ 7, 8 ] ] ] )
    , ( False, [ [ [ 1, 2 ], [ 3, 4 ] ], [ [ 5, 6, 7 ], [ 8, 9, 10 ] ] ] )
    ]


position : Point
position =
    [ 1, 0, 0 ]


direction : Point
direction =
    [ 0, 0, 0 ]


up : Point
up =
    [ 0, 0, 1 ]


validEyeData : List ( Bool, Eye )
validEyeData =
    [ -- 1
      ( True
      , { position = position
        , direction = direction
        , up = up
        }
      )
    , -- 2
      ( False
        --direction dimension /= eye dimension
      , { position = position
        , direction = [ 0, 0 ]
        , up = up
        }
      )
    , -- 3
      ( False
        --up dimension /= eye dimension
      , { position = position
        , direction = direction
        , up = [ 0, 1 ]
        }
      )
    , -- 4
      ( False
        --up.from == up.to
      , { position = position
        , direction = direction
        , up = [ 0, 0, 0 ]
        }
      )
    ]


body : Room
body =
    [ [ [ 0, 0, 0 ], [ 0, 1, 0 ], [ 1, 1, 0 ], [ 0, 0, 0 ] ]
    , [ [ 0, 0, 1 ], [ 0, 0, 1 ], [ 0, 1, 1 ], [ 0, 0, 0 ] ]
    ]


validSeerData : List ( Bool, Seer )
validSeerData =
    [ -- 1
      ( True
      , { body = body
        , eye = eye
        }
      )
    , -- 2: invalid body
      ( False
      , { body =
            [ [ [ 0, 0, 0 ], [ 0, 1, 0 ], [ 1, 1, 0 ], [ 0, 0, 0 ] ]
            , [ [ 0, 0 ], [ 0, 0 ], [ 0, 1 ], [ 0, 0 ] ]
            ]
        , eye = eye
        }
      )
    , -- 3: invalid eye
      ( False
      , { body = body
        , eye =
            { position = position
            , direction = [ 0, 0 ]
            , up = up
            }
        }
      )
    , -- 4: body dimension /= eye dimension
      ( False
      , { body = [ [ [ 0, 0 ], [ 0, 1 ], [ 1, 1 ], [ 0, 0 ] ] ]
        , eye = eye
        }
      )
    ]


validDistanceData : List ( Number, ( Point, Point ) )
validDistanceData =
    [ ( 0, ( [ 0, 0 ], [ 0, 0 ] ) )
    , ( 1, ( [ 0, 0 ], [ 0, 1 ] ) )
    , ( sqrt 2, ( [ 0, 0 ], [ 1, 1 ] ) )
    , ( sqrt <| 1 + 4 + 9 + 16, ( [ 0, 0, 0, 0 ], [ 1, 2, 3, 4 ] ) )
    ]
