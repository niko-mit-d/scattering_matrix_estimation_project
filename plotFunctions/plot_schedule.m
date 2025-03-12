function plot_schedule(tau, uk, param)
%PLOT_SCHEDULE Summary of this function goes here
%   Detailed explanation goes here
tau = [tau, param.sim.T];
uk = [uk, 0];

stairs(tau,uk);
xlim([0 param.sim.T]);
ylim([1 param.obs.N]);
yticks(1:param.obs.N);
title("Sensor schedule u(t)");
ylabel("Sensor nr.");
xlabel("t in sec");

end

