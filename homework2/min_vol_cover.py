import cvxpy as cvx
import numpy as np

# Create two scalar optimization variables.
x = cvx.Variable()
y = cvx.Variable()
r = cvx.Variable()

pts = np.array([[0.55, 0], [0.25, 0.35], [-0.2, 0.2], [-0.25, -0.1], \
 [0, -0.3], [0.4, -0.2], [0.2, 0.4], [0.2, 0.2]])

obj = cvx.Minimize(r)
#constraints = [None] * pts.shape[0]

#for i in range(0, pts.shape[0] - 1):
#    constraints[i] = [cvx.square(x - pts[i][0]) + cvx.square(y - pts[i][1]) <= cvx.square(r)]
i = 0
constraints = [cvx.sqrt(cvx.square(x - pts[0][0]) + cvx.square(y - pts[0][1])) - r <= 0, \
cvx.sqrt(cvx.square(x - pts[1][0]) + cvx.square(y - pts[1][1])) - r <= 0]

# Form and solve problem.
prob = cvx.Problem(obj, constraints)
prob.solve() # Returns the optimal value.
print("status:", prob.status)
print("optimal value", prob.value)
print("optimal var", x.value, y.value, r.value)
