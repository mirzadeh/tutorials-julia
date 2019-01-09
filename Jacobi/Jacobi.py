import numpy as np
from numba import jit

def relax_numpy(u, unew):
	unew[1:-1, 1:-1] = 0.25 * (u[:-2, 1:-1] + u[2:, 1:-1] + u[1:-1, :-2] + u[1:-1, 2:])

@jit(nopython=True, fastmath=True)
def relax_loop(u, unew):
	nx, ny = u.shape
	for i in range(1, nx-1):
		for j in range(1, ny-1):
			unew[i, j] = 0.25 * (u[i-1, j] + u[i+1, j] + u[i, j-1] + u[i, j+1])

def solve(u, relax = relax_numpy, tol = 1e-6):
	err = 1
	it = 1
	unew = u.copy()
	while err > tol:
		relax(u, unew)
		err = np.max(np.abs(u - unew))
		u, unew = unew, u
		it += 1

	print('took {0} iterations with err = {1:1.5e}'.format(it, err))

def run():
	u = np.zeros((250, 250))
	u[:,-1] = 1;
	solve(u, relax=relax_loop)

if __name__ == '__main__':
	import timeit
	t = timeit.default_timer()
	run()
	print('Took {} seconds'.format(timeit.default_timer() - t))