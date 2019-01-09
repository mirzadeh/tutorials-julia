import numpy as np
from numba import autojit

def relax_numpy(u):
	unew = u.copy()	
	unew[1:-1, 1:-1] = 0.25 * (u[:-2, 1:-1] + u[2:, 1:-1] + u[1:-1, :-2] + u[1:-1, 2:])

	return unew

@autojit
def relax_loop(u):
	nx, ny = u.shape
	unew = u.copy()
	for i in range(1, nx-1):
		for j in range(1, ny-1):
			unew[i, j] = 0.25 * (u[i-1, j] + u[i+1, j] + u[i, j-1] + u[i, j+1])

	return unew	

def solve(u, relax = relax_numpy, tol = 1e-6):
	err = 1
	it = 1
	while err > tol:
		unew = relax(u)
		err = np.max(np.abs(u - unew))
		u = unew
		it += 1

	print('took {0} iterations with err = {1:1.5e}'.format(it, err))
	return u

def run():
	u = np.zeros((300, 300))
	u[:,-1] = 1;
	u = solve(u, relax=relax_numpy)

run()