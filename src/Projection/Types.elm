--------------------------------------------------------------------------------
--
-- Types.elm
-- Types for Projection.elm.
-- Copyright (c) 2025 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE
--
----------------------------------------------------------------------


module Projection.Types exposing
    ( Number, Point, Vector, Matrix
    , Shape, Room
    , Eye, Seer
    , Object, Script, Tick, Function
    )

{-| Types for Projection.elm
This module allows you to project a point into one fewer dimensions,
given the eye looking at it.


# Basic types

@docs Number, Point, Vector, Matrix


# Things

@docs Shape, Room


# Seeing

@docs Eye, Seer


# Activity

@docs Object, Script, Tick, Function

-}


{-| A number. Currently a `Float`.
-}
type alias Number =
    Float


{-| An ordered list of `Number`s, one for each dimension.
-}
type alias Point =
    List Number


{-| Two points, from & to
-}
type alias Vector =
    { from : Point
    , to : Point
    }


{-| An n-dimensional matrix
-}
type alias Matrix =
    List Point


{-| An ordered list of `Point`s.

To draw a shape, draw a line from each point to the next one.

-}
type alias Shape =
    List Point


{-| A list of `Shape`s.
-}
type alias Room =
    List Shape


{-| The observer for the projection.

`direction` is from `position`.

`up` is from the origin.

-}
type alias Eye =
    { position : Point
    , direction : Point
    , up : Point
    }


{-| A `Shape` that can see.
-}
type alias Seer =
    { body : Room
    , eyes : List Eye
    }


{-| A moving `Seer`.
-}
type alias Object =
    { seer : Seer
    , script : Script
    }


{-| 1/10 second
-}
type alias Tick =
    Number


{-| A script that maps time to transformation.
-}
type alias Script =
    { name : String
    , function : Function
    }


{-| Different kinds of `Script` functions.
-}
type Function
    = Function (Tick -> Matrix)
    | UI --TODO
    | Interpreted String --interpreted Lisp?
