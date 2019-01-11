all: jacobi jacobi_slow mex

.PHONY: clean

clean:
	rm -rf Jacobi Jacobi_slow libjacobi* relax_mex.mexmaci64

jacobi:	Jacobi.c jacobi_kernel
	gcc -O3 -flto -o Jacobi Jacobi.c -L. -ljacobi

jacobi_slow: Jacobi_slow.c jacobi_kernel
	gcc -O3 -flto -o Jacobi_slow Jacobi_slow.c -L. -ljacobi

jacobi_kernel: jacobi_kernel.c jacobi_kernel.h
	gcc -O3 -flto -fPIC -shared jacobi_kernel.c -o libjacobi.dylib
	gcc -O0 -g -DDEBUG -shared jacobi_kernel.c -o libjacobi.g.dylib

mex: relax_mex.c jacobi_kernel
	mexcc -R2018a relax_mex.c -L. -ljacobi

