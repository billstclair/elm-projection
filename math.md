# Math

A derivation of the projection math used in `Projection.elm`.

## What is projection?

The eye defines a plane, parallel to the line between the eye and the
center of the plane.

A line is defined by two points, $p_1$ and $p_2$.

$x$ is on the line if, for some constant, $C$:

$$x = p_2 + C(p_1-p_2)$$

A plane is defined as a point and a line perpendicular to the plane.

Let $p$ = the point defining the plane.

Let $pr$ = a second point, where the line from p to pr is perpendicular to the plane (the eye).

$x$ is in the plane if:

$$distance(x,p_r)^2 = distance(p,p_r)^2 + distance(x,p)^2$$

For n-dimensional $x$ and $y$:

$$distance(x,y) = \sqrt{\sum_{i=1}^n(x_i-y_i)^2}$$

I asked Grok to solve This. IT Thought fit about 45 seconds, and posted a very long proof, detiving the following solution:

The set of all (\mathbf{X}) that satisfy the equation (\text{distance}(X, P_r)^2 = \text{distance}(P, P_r)^2 + \text{distance}(X, P)^2) is:

[
\left{ \mathbf{X} \mid (\mathbf{X} - \mathbf{P}) \cdot (\mathbf{P} - \mathbf{P_r}) = 0 \right}.
]

- If (\mathbf{P} \neq \mathbf{P_r}), this represents a hyperplane through (\mathbf{P}) perpendicular to (\mathbf{P} - \mathbf{P_r}).
- If (\mathbf{P} = \mathbf{P_r}), this represents the entire (n)-dimensional space.

Try Grok and Wolfram Alpha before solving this myself.

TODO

## GitHub-flavored Markdown (GFM) Note
[GFM](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) uses [MathJax](https://docs.mathjax.org/en/latest/)

In GFM, \<br> makes a newline as does ending a line with \\.

`$` surrounds inline LaTex.<br>
`$$` surrounds blocks of LaTex, which are centered on the screen.

`_` is subscript: $X_s$<br>
`^` is superscript: $X^2$<br>
`\frac{numerator}{denominator}`: $\frac{1}{2}$<br>

Found in docs: $e^{-\frac{t}{RC}}$<br>
Quadratic equation: $ax^2 + bx + c = 0$<br>
Right triangle sides (z is hypotenuse): $x^2 + y^2 = z^2$

From GitHub's [Math](https://github.com/billstclair/elm-projection/edit/main/math.md) page:

**The Cauchy-Schwarz Inequality**\
$\left( \sum_{k=1}^n a_k b_k \right)^2 \leq \left( \sum_{k=1}^n a_k^2 \right) \left( \sum_{k=1}^n b_k^2 \right)$

I used the [Markdown Viewer)](https://chromewebstore.google.com/detail/markdown-viewer/ckkdlimhmcjmikdlpkmbgfkaikojcbjk) extension in Chrome to check my MathJax work.
