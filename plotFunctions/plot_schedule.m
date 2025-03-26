function plot_schedule(tau, uk, param)
%PLOT_SCHEDULE Summary of this function goes here
%   Detailed explanation goes here
tau = [0, cumsum(tau)];
uk = [uk, 0];

figure("Name","Sensor schedule");
stairs(tau,uk);
xlim([0 param.sim.T]);
ylim([1 param.obs.N]);
yticks(1:param.obs.N);
title("Sensor schedule u(t)");
ylabel("Sensor nr.");
xlabel("t in sec");

end

