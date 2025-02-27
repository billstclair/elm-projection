[billstclair/projection](https://package.elm-lang.org/packages/billstclair/elm-projection/latest) is a library to project points to fewer dimensions.

It has a few basic types:

`Number` = a floating point number.

`Point` = a point, an ordered list of numbers. The list length is the number of dimensions. [x, y, z, d4, d5, ...]

`Vector` = two points (p1, p2)

`Shape` = an ordered list of points. [p1, p2, p3, ...]
To draw a `Shape`, draw a line from each point in the list to the next.

`Room` = a list of shapes: `[s1, s2, s3, ...]`

`Eye` (the viewpoint) = `{position : Point), direction : Vector, up : Vector}`

`Seer` is a `Room` (it's body) with an `Eye`

`project eye point -> (newEye, newPoint)`
The resulting eye & point have one fewer dimensions than the input.

The types are defined by `Projection.Types`

JSON encoders and decoders are in `Project.EncodeDecode`

Utility functions are in `Projection.Util`.

Projection functions are in `Projection`.

See [math.md](https://github.com/billstclair/elm-projection/blob/main/math.md) for details of the math involved.

The example is live at [gibgoygames.com/elm-projection](https://gibgoygames.com/elm-projection/).
