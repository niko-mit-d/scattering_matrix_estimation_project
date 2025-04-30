function [x_out, h_hat, P_plus] = run_pure_kalman_integrator(yk, tau, uk, param)
% Runs normal Kalman filter with double integrator as model
x_hat = zeros(2*param.sys.n, param.sim.dim_t);
x_hat(:,1) = param.kal.x_hat_0;
h_hat = zeros(param.obs.c, param.sim.dim_t);

k = piecewise_constant(tau, uk, param); % active sensor at time t

P_plus = zeros(2*param.sys.n, 2*param.sys.n, param.sim.dim_t);

% Tuning matrices chosen from param
P_plus(:,:,1) = param.kal.P0;
F = param.kal.F;
Q = param.kal.Q;
R = diag(2*param.sys.n);

for i=2:param.sim.dim_t
    H = [param.kal.C(:,:,k(i-1))];
    y = yk(:,i);

    P_minus = F*P_plus(:,:,i-1)*F.' + Q;
    K = P_minus*H.'/(H*P_minus*H.' + R);
    x_minus = F*x_hat(:,i-1);
    % x_hat == x_plus
    x_hat(:,i) = x_minus + K * (y - H*x_minus);
    P_plus(:,:,i) = (eye(2*param.sys.n) - K*H)*P_minus;
end
x_out = x_hat(1:param.sys.n,:);
end


