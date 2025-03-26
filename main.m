clc;
addpath(genpath("."));
set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');
%% Run parameter and config setting files
run run_parmeters.m

%% Simulate random scattering matrices
Sk = generate_scattering_matrices(param.sys.S0, param.sys.dim_S, param.sim.dim_t, "checkProperties", true);
xk = scattering_matrices_to_states(Sk);

%% Calculate sensor schedule
% Sample
random_sample = false;
if random_sample
    % n_measurements = 4;
    % u = randi(param.obs.N, n_measurements,1);
    % tau = randn(n_measurements, 1) * param.sim.T;
else
    tau = param.sim.T/8*ones(1,8);
    uk = [1, 2, 3, 1, 2, 3, 1, 2];
    % uk = repmat(uk,1, 10);
    % tau = param.sim.T/length(uk)*ones(1, length(uk));
end
yk = evaluate_y(xk, tau, uk, param);
% plot_schedule(tau, uk, param);
% plot_xk_overlayed_with_yk(xk, yk, param);

%% Running observer with not optimized values
run run_parmeters.m
[x_hat, ~] = run_observer(yk, tau, uk, param, "printDetails", false);
plot_performance(xk,x_hat,param, "Non-optimized parameters");
% plot_observer_results(x_hat, xk, param);

fprintf("Not optmized Loss: %.2f\n", calculate_performance(xk, yk, tau, uk, param, param.obs.K));
fprintf("Not optmized K vector: [%.2f; %.2f]\n\n", param.obs.K(1), param.obs.K(2));

%% Optimization to find suiting Ki parameters
% Global optimization using PSO
pso_options = optimoptions("particleswarm", "Display", "iter");
[K, Lval] = particleswarm(@(K)calculate_performance(xk, yk, tau, uk, param, K'), 2, [0;0], [20;20], pso_options);
K=K';

% % Optimization using fmincon
% opt_options = optimoptions("fmincon", "StepTolerance", 1e-10);
% [K, Lval] = fmincon(@(K)calculate_performance(xk, yk, tau, uk, param, K), param.opt.K0, [],[],[],[],[0;0],[Inf,Inf],[],opt_options);

param.obs.K = K;
[x_hat, ~] = run_observer(yk, tau, uk, param, "printDetails", false);
plot_performance(xk,x_hat,param, "Optimized parameters");
% plot_observer_results(x_hat, xk, param);

fprintf("Optmized Loss: %.2f\n", calculate_performance(xk, yk, tau, uk, param, param.obs.K));
fprintf("Optmized K vector: [%.2f; %.2f]\n", param.obs.K(1), param.obs.K(2));
