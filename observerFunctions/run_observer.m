function x_hat = run_observer(yk, tau, uk, param)
%RUN_OBSERVER Summary of this function goes here
x_hat = zeros(param.sys.n, param.sim.dim_t);
x_hat(:,1) = param.obs.x_hat_0; % initial condition
A = zeros(param.sys.n, 2);
k = piecewise_constant(tau, uk, param); % active sensor at time t

for i=2:param.sim.dim_t
    A(:,1) = -(yk(:,i)-param.obs.C(:,:,k(i))*x_hat(:,i-1))'*param.obs.C(:,:,k(i));
    h = constraint_combined(x_hat(:,i-1),param);
    dhdx = numerical_jacobian(@(x)constraint_combined(x,param), x_hat(:,i-1));
    A(:,2) = h'*dhdx;
    
    x_hat(:,i) = -pinv(A')*param.obs.K;
end

end

