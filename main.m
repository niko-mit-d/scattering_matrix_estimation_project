clc;
addpath(genpath("."));

%% Run parameter and config setting files
run run_parmeters.m

%% Simulate random scattering matrices
S0 = eye(param.sys.dim_S);
Sk = generate_scattering_matrices(S0, param.sys.dim_S, param.sim.dim_t, "checkProperties", true);
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
    tau = 0:0.25:0.75 * param.sim.T;
    uk = [1, 2, 3, 2];
end
yk = evaluate_y(xk, tau, uk, param);

% plot_schedule(tau, uk, param);
% plot_xk_overlayed_with_yk(xk, yk, param);

%%
constraint_symmetry(xk, param);