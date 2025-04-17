function [x_out, h_hat, P_plus] = run_PM_kalman(yk, tau, uk, param)
% Kalman filter using unitary constraints as perfect measurements and
% double integrator as system model
x_hat = zeros(2*param.sys.n, param.sim.dim_t);
x_hat(:,1) = param.kal.x_hat_0;
h_hat = zeros(param.obs.c, param.sim.dim_t);

k = piecewise_constant(tau, uk, param); % active sensor at time t

P_plus = zeros(2*param.sys.n, 2*param.sys.n, param.sim.dim_t);
P_plus(:,:,1) = param.kal.P0;

F = param.kal.F;
Q = param.kal.Q;
R = param.kal.R;

for i=2:param.sim.dim_t
    % Measurement preparation
    [h_hat(:,i-1), dhdx] = constraint_unitary(x_hat(1:param.sys.n,i-1),param);
    % extended output matrix / output including linearized constraints
    H = [param.kal.C(:,:,k(i-1)); dhdx, zeros(param.obs.c, param.sys.n)];
    y = [yk(:,i); dhdx*x_hat(1:param.sys.n,i-1)-h_hat(:,i-1)];

    P_minus = F*P_plus(:,:,i-1)*F.' + Q;
    K = P_minus*H.'/(H*P_minus*H.' + R);
    x_minus = F*x_hat(:,i-1);
    % x_hat == x_plus
    x_hat(:,i) = x_minus + K * (y - H*x_minus);
    P_plus(:,:,i) = (eye(2*param.sys.n) - K*H)*P_minus;
end
x_out = x_hat(1:param.sys.n,:);
end

