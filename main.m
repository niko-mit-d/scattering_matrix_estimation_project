clc;
addpath(genpath("."));

%% Run parameter and config setting files
run run_parmeters.m

%% Simulate random scattering matrices
Sk = generate_scattering_matrices(param_sys.dim_S, param_sim.dim_t, "checkProperties", true);
xk = scattering_matrices_to_states(Sk);
