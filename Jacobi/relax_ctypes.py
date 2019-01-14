import ctypes
import numpy as np
import numpy.ctypeslib as npct

# define types
double_ptr_t = npct.ndpointer(dtype=np.double, ndim=2)
int_t =  ctypes.c_int

# load the library
libjacobi = npct.load_library('libjacobi.so', '.')
libjacobi.relax.restype = None
libjacobi.relax.argtypes = [double_ptr_t, double_ptr_t, int_t, int_t]

def relax(u, unew):
    nx, ny = u.shape
    libjacobi.relax(u, unew, nx, ny)

if __name__ == '__main__':
    u = np.random.rand(3,3)
    print(u)
    relax(u, u)