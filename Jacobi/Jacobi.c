#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define nx 250
#define ny 250
#define tol 1e-6
#define max(a, b) a > b ? a : b;
#define index(i, j) (i)*ny + j

void relax(double *u, double *unew) {
	int i,j;

	for (i = 1; i < nx-1; i++) {
		for (j = 1; j  < ny-1; j++) {
			unew[index(i,j)] = 0.25 * ( u[index(i-1, j)] + u[index(i+1, j)] +
										u[index(i, j-1)] + u[index(i, j+1)] );
		}
	}
}

void boundary(double *u) {
	int i;

	for (i = 0; i < nx; i++) u[index(i, ny - 1)] = 1;
}

double absdiff(double *u, double *unew) {
	int i, j;

	double d = fabs(u[0] - unew[0]);
	for (i = 0; i < nx; i++) {
		for (j = 0; j < ny; j++) {
			d = max(d, fabs(u[index(i, j)] - unew[index(i, j)]));
		}
	}

	return d;
}

void solve(double *u, double *unew) {
	double err = 1;
	int it = 1;
	double *utmp;

	while (err > tol) {
		relax(u, unew);
		err = absdiff(u, unew);

		utmp = u; u = unew; unew = utmp;
		it++;
	}

	printf("took %d Iterations with err = %1.5e \n", it, err);
}

int main() {
	int i, j;
	double *u    = calloc(nx*ny, sizeof(double));
	double *unew = calloc(nx*ny, sizeof(double));

	boundary(u);
	boundary(unew);

	clock_t t = clock();
	solve(u, unew);
	printf("Took %f seconds\n", (double)(clock() - t) / CLOCKS_PER_SEC);

	free(u);
	free(unew);
}