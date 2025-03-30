clc;
addpath(genpath("."));
set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');
%% Run parameter and config setting files
run run_parmeters.m

%% Simulate random scattering matrices
[Sk, Sk_true] = generate_scattering_matrices(param, "checkProperties", true);
xk = scattering_matrices_to_states(Sk, param);
xk_true = scattering_matrices_to_states(Sk_true, param);
%% Calculate sensor schedule
% Sample
random_sample = false;
if random_sample
    % n_measurements = 4;
    % u = randi(param.obs.N, n_measurements,1);
    % tau = randn(n_measurements, 1) * param.sim.T;
else
    cycles = 50;
    tau = param.sim.T/(param.obs.N*cycles)*ones(1,param.obs.N*cycles);
    uk = repmat(1:param.obs.N,1,cycles);
end
yk = evaluate_y(xk, tau, uk, param);
% plot_schedule(tau, uk, param);
% plot_xk_overlayed_with_yk(xk, yk, param);

%% Running observer with not optimized values
% run run_parmeters.m
% [x_hat, ~] = run_observer(yk, tau, uk, param, "printDetails", false);
% plot_performance(xk,x_hat,param, "Non-optimized parameters");
% plot_observer_results(x_hat, xk, param);
% fprintf("Not optmized Loss: %.2f\n", calculate_performance(xk_true, yk, tau, uk, param, param.obs.K));
% fprintf("Not optmized K vector: [%.2f; %.2f]\n\n", param.obs.K(1), param.obs.K(2));

%% Optimization to find suiting Ki parameters
opt_technique = -1;

switch opt_technique
    case 0
        % Global optimization using PSO
        pso_options = optimoptions("particleswarm", "Display", "iter");
        [K, Lval] = particleswarm(@(K)calculate_performance(xk_true, yk, tau, uk, param, K'), 2, [0;0], [20;20], pso_options);
        K=K';
    case 1
        % Global optimization only K1 using PSO
        pso_options = optimoptions("particleswarm", "Display", "iter");
        [K1, Lval] = particleswarm(@(K)calculate_performance(xk_true, yk, tau, uk, param, [K; param.opt.K0(2)]), 1, 1, 20, pso_options);
        param.obs.K(1) = K1;
        param.obs.K(2) = param.opt.K0(2);
    case 2
        % Optimization using fmincon
        opt_options = optimoptions("fmincon", "StepTolerance", 1e-10);
        [K, Lval] = fmincon(@(K)calculate_performance(xk_true, yk, tau, uk, param, K), param.opt.K0, [],[],[],[],[5;0.001],[Inf,Inf],[],opt_options);
        param.obs.K = K;
    case 3
        % optimize only K1 using fmincon
        opt_options = optimoptions("fmincon", "StepTolerance", 1e-10);
        [K1, Lval] = fmincon(@(K1)calculate_performance(xk_true, yk, tau, uk, param, [K1;param.opt.K0(2)]), param.opt.K0(1), [],[],[],[],3,Inf,[],opt_options);
        param.obs.K(1) = K1;
        param.obs.K(2) = param.opt.K0(2);
    otherwise
        % default parameters
        % take from run_parameters
end

[x_hat, ~] = run_observer(yk, tau, uk, param, "printDetails", false);
plot_performance(xk,x_hat,param, "Optimized parameters");
% plot_observer_results(x_hat, xk, param);
plot_observer_results_with_noise(x_hat, xk, xk_true, param);
fprintf("Optmized Loss: %.2f\n", calculate_performance(xk_true, yk, tau, uk, param, param.obs.K));
fprintf("Optmized K vector: [%.2f; %.2f]\n", param.obs.K(1), param.obs.K(2));
