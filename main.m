clc;
addpath(genpath("."));

%% Run parameter and config setting files
run run_parmeters.m

%% Simulate random scattering matrices
Sk = generate_scattering_matrices(param_sys.dim_S, param_sim.dim_t, "checkProperties", true);
xk = scattering_matrices_to_states(Sk);
Sk2 = states_to_scattering_matrices(xk);
Sk == Sk2


%%
figure;
for i=1:param_sys.dim_S^2
    subplot(param_sys.dim_S, param_sys.dim_S, i);
    plot(param_sim.t, xk(i,:));
    hold on;
    plot(param_sim.t, xk(i+param_sys.dim_S,:));
    legend("Re", "Im");
end