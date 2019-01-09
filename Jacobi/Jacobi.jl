function relax(u, unew)
	unew[2:end-1, 2:end-1] = 0.25*(u[1:end-2, 2:end-1] + u[3:end, 2:end-1] +
								   u[2:end-1, 1:end-2] + u[2:end-1, 3:end])
end

function relax_loop(u, unew)
	nx, ny = size(u)

	for i in 2:nx-1
		for j in 2:ny-1
			unew[i, j] = 0.25*(u[i-1, j] + u[i+1, j] + u[i, j-1] + u[i, j+1])
		end
	end
end

function solve(u, tol = 1e-6)
	err = 1
	it = 1
	unew = copy(u)
	while err > tol
		relax_loop(u, unew)
		err = maximum(abs.(u - unew))
		u, unew = unew, u
		it += 1
	end

	println("took ", it, " iterations with err = ", err)
end

function run()
	u = zeros(250, 250)
	u[:, end] .= 1;
	solve(u)
end

@time run()