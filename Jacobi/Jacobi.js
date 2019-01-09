const nx = 100, ny = 100;
var u = new Array(nx*ny).fill(0);
var unew = new Array(nx*ny).fill(0);

function index(i,j) {
    return i*ny + j;
}

function relax(u, unew) {
    for (var i = 1; i < nx - 1; i++) {
        for (var j = 1; j < ny - 1; j++) {
            ind = index(i, j);
            unew[ind] = 0.25*(u[ind - ny] + u[ind + ny] + u[ind - 1] + u[ind + 1]);
       }
    }
}

function absmax(u, unew) {
    d = 0;
    for (var i = 0; i < u.length; i++) {
        d = Math.max(d, Math.abs(u[i] - unew[i]));
    }

    return d;
}

function solve(u, tol = 1e-6) {
    var err = 1;
    var it = 1;
    while (err > tol) {
    // for (var it = 0; it < 1000; it++) {
        relax(u, unew);
        err = absmax(u, unew);
        u = [...unew];
        it++;
    }

    console.log('Took %d iterations with err = ',it, err);
    return u;
}

function boundary(u) {
    for (var i = 0; i < nx; i++) u[index(i, ny-1)] = 1;
}

boundary(u);
boundary(unew);
u = solve(u);