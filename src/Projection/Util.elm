-------------------------------------------------------------------------------
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
    ( numberDimension, pointDimension, vectorDimension
    , shapeDimension, roomDimension, eyeDimension, seerDimension
    , isEyeValid, isRoomValid, isSeerValid, isShapeValid, isVectorValid
    , pointDistance
    , apply_id, apply0, apply1
    , plus, minus, times, divide, papply
    )

{-| Utilities for `Project.Types`


# Count Dimension

@docs numberDimension, pointDimension, vectorDimension
@docs shapeDimension, roomDimension, eyeDimension, seerDimension


# Check Validity

@docs isEyeValid, isRoomValid, isSeerValid, isShapeValid, isVectorValid


# `distance`

This IS a metric space, so it has a `distance` function.

Imagine a package for non-metric spaces.

@docs pointDistance


# Apply, Elm Style

@docs apply_id, apply0, apply1


# Point math

@docs plus, minus, times, divide, papply

-}

import List.Extra as LE
import Projection.Types
    exposing
        ( Eye
        , Number
        , Point
        , Room
        , Seer
        , Shape
        , Vector
        )


{-| A number has 0 dimension.
-}
numberDimension : Number -> Int
numberDimension number =
    0


{-| Count the dimensions of a `Point`.
-}
pointDimension : Point -> Int
pointDimension =
    List.length


{-| Count the dimensions of a `Vector`.
-}
vectorDimension : Vector -> Int
vectorDimension =
    .from >> pointDimension


{-| Count the dimensions of a `Shape`.
-}
shapeDimension : Shape -> Int
shapeDimension shape =
    case List.head shape of
        Nothing ->
            0

        Just p ->
            pointDimension p


{-| Count the dimensions of a `Room`.
-}
roomDimension : Room -> Int
roomDimension room =
    case List.head room of
        Nothing ->
            0

        Just shape ->
            shapeDimension shape


{-| Count the dimensions of an `Eye`.
-}
eyeDimension : Eye -> Int
eyeDimension =
    .position >> pointDimension


{-| Count the dimensions of a `Seer`.
-}
seerDimension : Seer -> Int
seerDimension =
    .body >> roomDimension


{-| A `Vector` is valid if both of its ends have the same number of dimension.
-}
isVectorValid : Vector -> Bool
isVectorValid vector =
    pointDimension vector.from == pointDimension vector.to


{-| A `Shape` is valid if all of its `Point`s are of the same dimension.
-}
isShapeValid : Shape -> Bool
isShapeValid shape =
    List.map pointDimension shape
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
        && (List.map shapeDimension room
                |> LE.unique
                |> List.length
                |> (>) 2
           )


{-| An `Eye` is valid if `eye.direction` is of the same dimension as
Eye.position, `eye.up` is of the same dimension as eye.direction, and
eye.up is not the origin.
-}
isEyeValid : Eye -> Bool
isEyeValid eye =
    (pointDimension eye.position == pointDimension eye.direction)
        -- This should probably demand some minimum distance
        && (pointDimension eye.position == pointDimension eye.up)
        -- Likewise
        && (eye.up /= List.repeat (pointDimension eye.up) 0)
        && (pointDimension eye.up == pointDimension eye.position)


{-| A `Seer` is valid if both its `eye` and its `body` are valid
and have the same number of dimension.
-}
isSeerValid : Seer -> Bool
isSeerValid seer =
    isRoomValid seer.body
        && isEyeValid seer.eye
        && (roomDimension seer.body == eyeDimension seer.eye)


{-| I don't think Elm has apply, and I discovered why when I wrote it.
You need an ID function, as a basis for the value, when there are no args.
-}
apply_id : y -> (x -> y -> y) -> List x -> y
apply_id id f xs =
    let
        applyer f2 sum xs2 =
            case xs2 of
                [] ->
                    sum

                x :: tail ->
                    applyer f2
                        (f2 x sum)
                        tail
    in
    applyer f id xs


{-| `apply` for functions with an id of 0.
-}
apply0 : (a -> number -> number) -> List a -> number
apply0 =
    apply_id 0


{-| `apply` for functions with an id of 1.
-}
apply1 : (a -> number -> number) -> List a -> number
apply1 =
    apply_id 1


{-| The distance between two points.

    sqrt ((p1 - p2) ^ 2)

-}
pointDistance : Point -> Point -> Number
pointDistance p1 p2 =
    List.map2 (-) p1 p2
        |> List.map (\x -> x ^ 2)
        |> apply0 (+)
        |> sqrt


{-| Add points
-}
plus : Point -> Point -> Point
plus p1 p2 =
    List.map2 (+) p1 p2


{-| Subtract points
-}
minus : Point -> Point -> Point
minus p1 p2 =
    List.map2 (-) p1 p2


{-| Multiply points.
-}
times : Point -> Point -> Point
times p1 p2 =
    List.map2 (*) p1 p2


{-| Divide points.
-}
divide : Point -> Point -> Point
divide p1 p2 =
    List.map2 (/) p1 p2


{-| Apply a function to two points.
-}
papply : (Number -> Number -> Number) -> Point -> Point -> Point
papply f p1 p2 =
    List.map2 f p1 p2
