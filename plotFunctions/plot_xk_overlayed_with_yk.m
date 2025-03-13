function plot_xk_overlayed_with_yk(xk, yk, param)
%PLOT_XK_OVERLAYED_WITH_YK Summary of this function goes here
%   Detailed explanation goes here

plot_xk(xk,param);
hold on;
for i=1:param.sys.dim_S^2
    subplot(param.sys.dim_S, param.sys.dim_S, i);
    row = ceil(i / param.sys.dim_S);
    plot(param.sim.t, real(yk(row,:)), ":", "DisplayName","Re(y)");
    plot(param.sim.t, imag(yk(row,:)), ":", "DisplayName","Im(y)");
end
end

