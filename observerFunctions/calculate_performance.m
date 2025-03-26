function L = calculate_performance(xk, yk, tau, uk, param, K)
%CALCULATE_PERFORMANCE Summary of this function goes here
%   Detailed explanation goes here

param.obs.K = K;
[x_hat, h_hat] = run_observer(yk, tau, uk, param);

L_x = sum(vecnorm(x_hat - xk,2)); % Sum of norms of state following error
L_h = sum(vecnorm(h_hat,2));

L = param.opt.w_x*L_x + param.opt.w_h*L_h;
end

