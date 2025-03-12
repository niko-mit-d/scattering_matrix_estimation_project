function yk = evaluate_y(xk, tau, uk, param)
%EVALUATE_Y This function calculates y, the output of the scheduler using
%the schedule (tau,uk) passed.
n_measurements = length(uk);
yk = zeros(size(param.obs.C,1), param.sim.dim_t);

for i=1:n_measurements
    yk(:,param.sim.t>=tau(i)) = param.obs.C(:,:,uk(i))*xk(:,param.sim.t>=tau(i));
end
end

