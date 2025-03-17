function plot_performance(x,x_hat,h_norm,param)
%PLOT_PERFORMANCE Summary of this function goes here


figure;
subplot(1,2,1);
plot(param.sim.t,abs(x-x_hat)); grid on;
title("||x-x_{hat}||");
xlabel("t in sec");

subplot(1,2,2);
plot(param.sim.t, h_norm); grid on;
legend(["h_s", "h_u"]);
title("||h(t)||");
end

