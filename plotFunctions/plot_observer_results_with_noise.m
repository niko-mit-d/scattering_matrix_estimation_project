function plot_observer_results_with_noise(x_hat, xk_noise, xk_true, param)
%PLOT_OBSERVER_RESULTS_WITH_NOISE Summary of this function goes here
%   Detailed explanation goes here

plot_observer_results(x_hat, xk_true, param)
S_noise = states_to_scattering_matrices(xk_noise, param);

hold on;
for i=1:param.sys.dim_S^2
    subplot(param.sys.dim_S, param.sys.dim_S, i);
    col = mod(i-1, param.sys.dim_S) + 1;
    row = ceil(i / param.sys.dim_S);


    plot(param.sim.t, real(squeeze(S_noise(row,col,:))), ":", "DisplayName","$Re(x_{noise})$", "Color", "#0072BD");
    plot(param.sim.t, imag(squeeze(S_noise(row,col,:))), ":","DisplayName","$Im(x_{noise})$", "Color", "#D95319");
end

end

