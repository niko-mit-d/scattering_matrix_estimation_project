function plot_h_norm(h_hat, param)
%PLOT_H_NORM Summary of this function goes here

figure;
plot(param.sim.t, vecnorm(h_hat));
title("||h(t)||");
end

