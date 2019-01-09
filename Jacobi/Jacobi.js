const nx = 5, ny = 5;
var u = new Array(nx*ny).fill(0);
var unew = new Array(nx*ny).fill(0);

function index(i,j) {
    return i*ny + j;
}
function relax(u, unew) {
    for (var i = 1; i < nx - 1; i++) {
        for (var j = 1; j < ny - 1; j++) {
            unew[index(i, j)] = 0.25*(u[index(i-1, j)] + u[index(i+1, j)] +
                                      u[index(i, j-1)] + u[index(i, j+1)]);
        }
    }
}

function solve(u, tol = 1e-6) {
    var err = 1;
    // while (err > tol) {
    for (var it = 0; it < 1000; it++) {
        relax(u, unew);
        u = unew;
    }
}

function boundary(u) {
    for (var i = 0; i < nx; i++) u[index(i, ny-1)] = 1;
}

boundary(u);
solve(u);
console.log(u);