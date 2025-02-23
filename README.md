[billstclair/projection](https://package.elm-lang.org/packages/billstclair/projection/latest) is a library to project points to fewer dimensions.

It has a few basic types:

point = a point, an ordered list of numbers. The list length is the number of dimensions. [x, y, z, d4, d5, ...]

shape = an ordered list of points. The shape is drawn by drawing a line from each point in the list to the next. [p1, p2, p3, ...]

room = a list of shapes [s1, s2, s3, ...]

vector = two points (p1, p2)

eye (the viewpoint) = {position (point), direction (vector), rotation (number)}

projection eye point = (newEye, newPoint)

