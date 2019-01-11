all: jacobi jacobi_slow mex

.PHONY: clean

clean:
	rm -rf Jacobi Jacobi_slow libjacobi* relax_mex.mex*

jacobi:	Jacobi.c jacobi_kernel
	$(CC) -O3 -flto -o Jacobi Jacobi.c -L. -ljacobi

jacobi_slow: Jacobi_slow.c jacobi_kernel
	$(CC) -O3 -flto -o Jacobi_slow Jacobi_slow.c -L. -ljacobi

jacobi_kernel: jacobi_kernel.c jacobi_kernel.h
	$(CC) -O3 -flto -fPIC -shared jacobi_kernel.c -o libjacobi.so
	$(CC) -O0 -g -fPIC -DDEBUG -shared jacobi_kernel.c -o libjacobi.g.so

mex: relax_mex.c jacobi_kernel
	$(MEX) -R2018a relax_mex.c -L. -ljacobi

