#include "jacobi_kernel.h"
#include <stdio.h>

#define index(i, j) (i)*ny + j

void relax(double *u, double *unew, int nx, int ny) {
    int i, j;

#ifdef DEBUG
    printf("%d %d %p %p\n", nx, ny, (void *)u, (void *)unew);
    for (i = 0; i < nx; i++) {
        for (j = 0; j < ny; j++) {
            printf("%f ", u[index(i,j)]);
        }
        printf("\n");
    }
#endif

    for (i = 1; i < nx-1; i++) {
        for (j = 1; j < ny-1; j++) {
            unew[index(i,j)] = 0.25 * (u[index(i-1,j)] + u[index(i+1,j)] + u[index(i,j-1)] + u[index(i,j+1)]);
        }
    }
}