--------------------------------------------------------------------------------
--
-- Util.elm
-- Utilities for `Projection.Types`
-- Copyright (c) 2025 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE
--
----------------------------------------------------------------------


module Projection.Util exposing
    ( numberDimensions, pointDimensions, vectorDimensions
    , shapeDimensions, roomDimensions, eyeDimensions, seerDimensions
    , isEyeValid, isRoomValid, isSeerValid, isShapeValid, isVectorValid
    )

{-| Utilities for `Project.Types`


# Count Dimensions

@docs numberDimensions, pointDimensions, vectorDimensions
@docs shapeDimensions, roomDimensions, eyeDimensions, seerDimensions


# Check Validity

@docs isEyeValid, isRoomValid, isSeerValid, isShapeValid, isVectorValid

-}

import List.Extra as LE
import Projection.Types
    exposing
        ( Eye
        , Number
        , Point
        , Room
        , Rotation
        , Seer
        , Shape
        , Vector
        )


{-| A number has 0 dimensions.
-}
numberDimensions : Number -> Int
numberDimensions number =
    0


{-| Count the dimensions in a `Point`.
-}
pointDimensions : Point -> Int
pointDimensions point =
    List.length point


{-| Count the dimensions in a `Vector`.
-}
vectorDimensions : Vector -> Int
vectorDimensions vector =
    vector.from |> pointDimensions


{-| Count the dimensions in a `Shape`.
-}
shapeDimensions : Shape -> Int
shapeDimensions shape =
    case List.head shape of
        Nothing ->
            0

        Just p ->
            pointDimensions p


{-| Count the dimensions in a `Room`.
-}
roomDimensions : Room -> Int
roomDimensions room =
    case List.head room of
        Nothing ->
            0

        Just shape ->
            shapeDimensions shape


{-| Count the dimensions in an `Eye`.
-}
eyeDimensions : Eye -> Int
eyeDimensions eye =
    eye.position |> pointDimensions


{-| Count the dimensions in a `Seer`.
-}
seerDimensions : Seer -> Int
seerDimensions seer =
    seer.room |> roomDimensions


{-| A `Vector` is valid if both of its ends have the same number of dimension
-}
isVectorValid : Vector -> Bool
isVectorValid vector =
    pointDimensions vector.from == pointDimensions vector.to


{-| A `Shape` is valid if all of its `Point`s are of the same dimension.
-}
isShapeValid : Shape -> Bool
isShapeValid shape =
    List.map pointDimensions shape
        |> LE.unique
        |> List.length
        |> (>) 2


{-| A `Room` is valid if all of its `Shape`s are valid and have the same dimension.
-}
isRoomValid : Room -> Bool
isRoomValid room =
    (List.map isShapeValid room
        |> LE.unique
        |> (\x -> x == [] || x == [ True ])
    )
        && (List.map shapeDimensions room
                |> LE.unique
                |> List.length
                |> (>) 2
           )


{-| An `Eye` is valid if its direction is valid and its position
has one more dimension than its direction.
-}
isEyeValid : Eye -> Bool
isEyeValid eye =
    isVectorValid eye.direction
        && (pointDimensions eye.position
                == (vectorDimensions eye.direction + 1)
           )


{-| A `Seer` is valid if
-}
isSeerValid : Seer -> Bool
isSeerValid seer =
    isRoomValid seer.room
        && isEyeValid seer.eye
        && (roomDimensions seer.room == eyeDimensions seer.eye)
