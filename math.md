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

I asked Grok to solve This. It thought for about 45 seconds, and posted a [very long proof](./grok.md), ending with the following solution:

* If $p≠p_r$ : The solution is the hyperplane defined by: $\sum_{i=1}^{n}(x_i−p_i)(p_{r_i}−p_{i})=0$
* If $p=p_r$ : All points $x∈R_n$ are solutions.
This describes the set of points ( x ) satisfying the given distance equation, typically forming a hyperplane unless $p$ coincides with $p_r$

Now we just need to intersect the plane with the line from the eye to $p$.

That point is described by two equations:

$$\sum_{i-1}^{n}(x_i-p_{e_i})(p_{e_i}-p_{p_i})=0$$
$$x=p_e+C(p-p_e)$$

Where $p_e$ is the eye position, $p_p$ is the plane center position, and $p$ is the point position.

The second equation is really $n$ equations:

$$x_i=p_{e_i}+C(p_i-p_{e_i})$$

Grok [solved](grok-projection.html) this too:

$$x = p_e - \frac{||p_e-p_p||^2}{(p-p_e)\bullet(p_e-p_p)}(p-p_e)$$

and Grok fixed the bug in my first equation, which should have been:

$$\sum_{i-1}^{n}(x_i-p_i)(p_{e_i}-p_{p_i})=0$$

Now I just have to express that equation in n-1 dimensions, the coordinate system of the plane, with up as appropriate.

I asked Grok to do the whole thing, with only an English description of what I wanted. [grok-projection-math.html](grok-projection-math.html) is the result.

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

I used the [Markdown Viewer](https://chromewebstore.google.com/detail/markdown-viewer/ckkdlimhmcjmikdlpkmbgfkaikojcbjk) extension in Chrome to check my MathJax work.
