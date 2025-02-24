# Math

A derivation of the projection math used in `Projection.elm`.

## What is projection?

The eye defines a plane, parallel to the line between the eye and the
center of the plane.

A plane is all points with one coordinate the same. I'm dropping the
final dimension.

$$p\ =\ (x,\ y,\ z,\ C)$$

But rotated. [My brain now hurts, so I'll come back to this]

## GitHub-flavored Markdown (GFM) Note
[GFM](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) uses [MathJax](https://docs.mathjax.org/en/latest/)

In GFM, \<br> makes a newline as does ending a line with \\.

$ surrounds inline LaTex.<br>
$$ surrounds blocks of LaTex, but I dont know how to make a newline.<br>

_ is subscript: $X_s$<br>
^ is superscript: $X^2$<br>
frac{numerator}{denominator}: $frac{1}{2}<br>
I've tried lost of Stack Exchange ideas for newline, but none work.

$Found\ in\ docs: e^{-\frac{t}{RC}}$<br>
$Quadratic\ equation:\ ax^2\ +\ bx\ +\ c\ =\ 0$<br>
$Right\ triangle\ sides\ (z\ is\ hypotenuse):\ x^2\ +\ y^2\ =\ z^2$

From GitHub's [Math](https://github.com/billstclair/elm-projection/edit/main/math.md) page:

**The Cauchy-Schwarz Inequality**\
$$\left( \sum_{k=1}^n a_k b_k \right)^2 \leq \left( \sum_{k=1}^n a_k^2 \right) \left( \sum_{k=1}^n b_k^2 \right)$$
