tic
run()
toc

function unew = relax(u)
    unew = u;
	unew(2:end-1, 2:end-1) = 0.25*(u(1:end-2, 2:end-1) + u(3:end, 2:end-1) + ...
								   u(2:end-1, 1:end-2) + u(2:end-1, 3:end));
end

function unew = relax_loop(u)
	nx = size(u,1);
    ny = size(u,2);
    unew = u;
    
    for i = 2:nx-1		
        for j = 2:ny-1
			unew(i, j) = 0.25*(u(i-1, j) + u(i+1, j) + u(i, j-1) + u(i, j+1));
		end
	end
end

function solve(u)
	err = 1;
    tol = 1e-6;
	it = 1;
    while err > tol
		unew = relax_mex(u);
		err = max(max(abs(u - unew)));
		u = unew;

        it = it + 1;
    end
    
	fprintf("took %d iterations with err = %1.5e\n", it, err)
end

function run()
	u = zeros(200, 200);
	u(:, end) = 1;
	solve(u)    
end
