function plot_observer_results(x_hat, xk, param)
%PLOT_OBSERVER_RESULTS Summary of this function goes here
%   Detailed explanation goes here
plot_xk(xk,param);
S_hat = states_to_scattering_matrices(x_hat,param);

hold on;
for i=1:param.sys.dim_S^2
    subplot(param.sys.dim_S, param.sys.dim_S, i);
    col = mod(i-1, param.sys.dim_S) + 1;
    row = ceil(i / param.sys.dim_S);


    plot(param.sim.t, real(squeeze(S_hat(row,col,:))), "DisplayName","$Re(\hat{x})$", "Color", "r");
    plot(param.sim.t, imag(squeeze(S_hat(row,col,:))),"DisplayName","$Im(\hat{x})$", "Color", "g");
end
end

