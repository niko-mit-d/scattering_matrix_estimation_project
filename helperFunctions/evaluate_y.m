function yk = evaluate_y(xk, tau, uk, param)
%EVALUATE_Y This function calculates y, the output of the scheduler using
%the schedule (tau,uk) passed.
n_measurements = length(uk);
switching_times = [0, cumsum(tau)];
yk = zeros(2*param.obs.N, param.sim.dim_t);

for i=1:n_measurements
    yk(:,param.sim.t>=switching_times(i)) = param.obs.C(:,:,uk(i))*xk(:,param.sim.t>=switching_times(i));
end
% add noise to measurement
yk = yk + param.sys.sigma_y*(rand(size(yk))-0.5);
end

