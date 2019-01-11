#include "jacobi_kernel.h"
#include <mex.h>
#include <matrix.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // get input
    double *u = mxGetDoubles(prhs[0]);
    mwSize nx = mxGetN(prhs[0]);
    mwSize ny = mxGetM(prhs[0]);

    // allocate the output **using MATALB**
    plhs[0] = mxCreateDoubleMatrix(ny, nx, mxREAL);
    double *unew = mxGetDoubles(plhs[0]);

    // call the kernel
    relax(u, unew, nx, ny);

    // fill in the boundary
    for (int j = 0; j < ny; j++) unew[(nx-1)*ny + j] = 1;
}