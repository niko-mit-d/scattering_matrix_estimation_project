function [x_out, h_hat, P_plus] = run_pure_kalman(yk, tau, uk, param)
% Runs normal Kalman filter model-free (F=0)
x_hat = zeros(param.sys.n, param.sim.dim_t);
x_hat(:,1) = scattering_matrices_to_states(param.sys.S0, param);
h_hat = zeros(param.obs.c, param.sim.dim_t);

k = piecewise_constant(tau, uk, param); % active sensor at time t

P_plus = zeros(param.sys.n, param.sys.n, param.sim.dim_t);

% Choose tuning matrices here!
P_plus(:,:,1) = .1*eye(param.sys.n);
F = zeros(param.sys.n);
Q = 10*eye(param.sys.n);
R = 1*diag([1 1 1 1 1 1]);

for i=2:param.sim.dim_t
    % extended output matrix / output including linearized constraints
    H = param.kal.C(:,1:param.sys.n,k(i-1));
    y = yk(:,i);

    P_minus = F*P_plus(:,:,i-1)*F.' + Q;
    K = P_minus*H.'/(H*P_minus*H.' + R);
    x_minus = F*x_hat(:,i-1);
    % x_hat == x_plus
    x_hat(:,i) = x_minus + K * (y - H*x_minus);
    P_plus(:,:,i) = (eye(param.sys.n) - K*H)*P_minus;
end
x_out = x_hat;
end

