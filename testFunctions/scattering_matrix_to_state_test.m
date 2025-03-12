% Quick script to check, if transformations between
% scattering matrices and state space are correct.
clc;

Ain = randn(param_sys.dim_S^2*param_sim.dim_t,1);
Ain = Ain - 1i*Ain;
Ain = reshape(Ain, [param_sys.dim_S, param_sys.dim_S, param_sim.dim_t]);

xx = scattering_matrices_to_states(Ain);
Aout = states_to_scattering_matrices(xx);

Ain(:,:,1:3)
xx(:,1:3)
Aout(:,:,1:3)
fprintf("Ain and Aout are the same: %d\n", all(Ain(:) == Aout(:)));