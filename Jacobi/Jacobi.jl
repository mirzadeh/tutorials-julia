@views @inbounds function relax(u::Array{Float64, 2}, unew::Array{Float64, 2})
	@. unew[2:end-1, 2:end-1] = 0.25*(u[1:end-2, 2:end-1] + u[3:end, 2:end-1] +
								   u[2:end-1, 1:end-2] + u[2:end-1, 3:end])
end

function relax_loop(u::Array{Float64, 2}, unew::Array{Float64, 2})
	nx, ny = size(u)

	@inbounds for j in 2:ny-1
		@simd for i in 2:nx-1
			unew[i, j] = 0.25*(u[i-1, j] + u[i+1, j] + u[i, j-1] + u[i, j+1])
		end
	end
end

function relax_c(u::Array{Float64, 2}, unew::Array{Float64, 2})
	nx, ny = size(u)
	ccall((:relax, "libjacobi.so"), Cvoid, (Ref{Float64}, Ref{Float64}, Int32, Int32), u, unew, nx, ny)
end

function absdiff(u::Array{Float64, 2}, unew::Array{Float64, 2})
	nx, ny = size(u)
	du = 0
	@inbounds for j in 2:ny-1
		@simd for i in 2:nx-1
			du = max(du, abs(u[i,j] - unew[i,j]))
		end
	end

	return du
end

function solve(u::Array{Float64, 2}, tol = 1e-6)
	err = 1
	it = 1
	unew = copy(u)
	# du = similar(u)
	while err > tol
		relax_loop(u, unew)
		# err = absdiff(u, unew)
		# err = maximum(abs(x - y) for (x, y) in zip(u, unew))
		err = mapreduce(x -> abs(x[1] - x[2]), max, zip(u, unew))
		# @. du = abs(u - unew)
		# err = maximum(du)
		u, unew = unew, u
		it += 1
	end

	println("took ", it, " iterations with err = ", err)
end

function run()
	u = zeros(200, 200)
	u[:, end] .= 1;
	solve(u)
end

using BenchmarkTools
@btime run()