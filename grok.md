Step 1: Define the Distance Terms
The squared Euclidean distance between two points ( a ) and ( b ) in 
R
n
 is defined as:
distance
(
a
,
b
)
2
=
∑
i
=
1
n
(
a
i
−
b
i
)
2
Applying this to each term in the equation:
* Distance from ( x ) to pr:  distance(x,pr)2=∑i=1n(xi−pri)2
* Distance from ( p ) to pr:  distance(p,pr)2=∑i=1n(pi−pri)2
* Distance from ( x ) to ( p ):  distance(x,p)2=∑i=1n(xi−pi)2
Substituting these into the given equation, we get:
∑
i
=
1
n
(
x
i
−
p
r
i
)
2
=
∑
i
=
1
n
(
p
i
−
p
r
i
)
2
+
∑
i
=
1
n
(
x
i
−
p
i
)
2

Step 2: Geometric Interpretation Using Vectors
The equation resembles the Pythagorean theorem, hinting at a right-angle condition. To explore this, define the following vectors:
* a=p−pr (vector from pr to ( p )),
* b=x−p (vector from ( p ) to ( x )).
The vector from 
p
r
 to ( x ) can be written as:
x
−
p
r
=
(
x
−
p
)
+
(
p
−
p
r
)
=
b
+
a
Now, rewrite the equation:
* Left-hand side:  distance(x,pr)2=∥x−pr∥2=∥a+b∥2
* Right-hand side:  distance(p,pr)2+distance(x,p)2=∥p−pr∥2+∥x−p∥2=∥a∥2+∥b∥2
The equation becomes:
∥
a
+
b
∥
2
=
∥
a
∥
2
+
∥
b
∥
2
Expand the left-hand side using the dot product:
∥
a
+
b
∥
2
=
(
a
+
b
)
⋅
(
a
+
b
)
=
∥
a
∥
2
+
2
a
⋅
b
+
∥
b
∥
2
Equate both sides:
∥
a
∥
2
+
2
a
⋅
b
+
∥
b
∥
2
=
∥
a
∥
2
+
∥
b
∥
2
Subtract 
∥
a
∥
2
 and 
∥
b
∥
2
 from both sides:
2
a
⋅
b
=
0
⟹
a
⋅
b
=
0
Thus, the vectors 
a
=
p
−
p
r
 and 
b
=
x
−
p
 are orthogonal:
(
p
−
p
r
)
⋅
(
x
−
p
)
=
0

Step 3: Express the Condition as a Hyperplane
In component form, the orthogonality condition is:
∑
i
=
1
n
(
p
i
−
p
r
i
)
(
x
i
−
p
i
)
=
0
This is the equation of a hyperplane in 
R
n
 that:
* Passes through the point ( p ) (since substituting x=p gives 0=0),
* Is perpendicular to the vector p−pr.
Thus, all points ( x ) satisfying the original equation lie on this hyperplane, assuming 
p
≠
p
r
.

Step 4: Special Case When 
p
=
p
r
If 
p
=
p
r
, substitute into the original equation:
* Left side: distance(x,pr)2=∥x−pr∥2,
* Right side: distance(p,pr)2+distance(x,p)2=0+∥x−pr∥2.
The equation becomes:
∥
x
−
p
r
∥
2
=
∥
x
−
p
r
∥
2
This is trivially true for all 
x
∈
R
n
. Therefore, if 
p
=
p
r
, every point ( x ) in 
R
n
 satisfies the equation.

Step 5: Dimensionality Considerations
The solution's nature depends on the dimension ( n ):
* n=1 (1D space):The equation (x−p)(p−pr)=0 implies x=p (if p≠pr). Verify:  
    * Left side: (p−pr)2,  
    * Right side: (p−pr)2+(p−p)2=(p−pr)2, which holds.So, the solution is the single point x=p.
* n=2 (2D space):The solution is a line (a 1D hyperplane) perpendicular to p−pr passing through ( p ).
* n=3 (3D space):The solution is a plane (a 2D hyperplane).
* General ( n ):The solution is an (n−1)-dimensional hyperplane, unless p=pr, where it’s the entire Rn.
Since the problem doesn’t specify ( n ), we provide the general solution.

Final Answer
* If p≠pr:The solution is the hyperplane defined by:  ∑i=1n(xi−pi)(pi−pri)=0
* If p=pr:All points x∈Rn are solutions.
This describes the set of points ( x ) satisfying the given distance equation, typically forming a hyperplane unless ( p ) coincides with 
p
r
.
