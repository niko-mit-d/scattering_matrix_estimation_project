clc;
addpath(genpath("."));

%% Run parameter and config setting files
run run_parmeters.m

%% Simulate random scattering matrices
Sk = generate_scattering_matrices(param.sys.S0, param.sys.dim_S, param.sim.dim_t, "checkProperties", true);
xk = scattering_matrices_to_states(Sk);
Sk2 = states_to_scattering_matrices(xk);

%% Calculate sensor schedule

% Sample
random_sample = false;

if random_sample
    % n_measurements = 4;
    % u = randi(param.obs.N, n_measurements,1);
    % tau = randn(n_measurements, 1) * param.sim.T;
else
    tau = param.sim.T/4*ones(1,4);
    uk = [1, 1, 1, 1];
    % uk = repmat(uk,1, 10);
    % tau = param.sim.T/length(uk)*ones(1, length(uk));
end
yk = evaluate_y(xk, tau, uk, param);

%plot_schedule(tau, uk, param);
% plot_xk_overlayed_with_yk(xk, yk, param);
%%
[x_hat, h_hat] = run_observer(yk, tau, uk, param, "printDetails", true);
% plot_observer_results(x_hat, xk, param);

%%
plot_performance(xk,x_hat,param);