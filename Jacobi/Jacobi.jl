function relax(u)
	unew = copy(u)
	unew[2:end-1, 2:end-1] = 0.25*(u[1:end-2, 2:end-1] + u[3:end, 2:end-1] + 
								   u[2:end-1, 1:end-2] + u[2:end-1, 3:end])

	return unew
end

function solve(u, tol = 1e-6)
	err = 1
	it = 1
	while err > tol
		unew = relax(u)
		err = maximum(abs.(u - unew))
		u = unew
		it += 1
	end

	println("took ", it, " iterations with err = ", err)
	return u
end

function run()
	u = zeros(250, 250)
	u[:, end] .= 1;
	u = solve(u)
end

@time run()