function plot_performance(x,x_hat,param)
%PLOT_PERFORMANCE Summary of this function goes here
for i=1:param.sim.dim_t
    Skk = states_to_scattering_matrices(x_hat(:,i));
    h_norm(1,i) = norm(Skk-Skk.');
    h_norm(2,i) = norm(Skk' * Skk - eye(size(Skk)));
end

figure;
subplot(1,2,1);
plot(param.sim.t,abs(x-x_hat)); grid on;
title("$\vert\vert x-\hat{x} \vert\vert$", "Interpreter","latex");
xlabel("t in sec");

subplot(1,2,2);
plot(param.sim.t, h_norm); grid on;
legend(["$h_s$", "$h_u$"]);
title("$\vert\vert h(t) \vert\vert$");
end

