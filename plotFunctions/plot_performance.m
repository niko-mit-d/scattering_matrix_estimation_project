function plot_performance(x,x_hat,param,window_title)
%PLOT_PERFORMANCE Summary of this function goes here
constraint_symmetry(x_hat, param);

for i=1:param.sim.dim_t
    h_norm(1,i) = vecnorm(constraint_symmetry(x_hat(:,i), param),2);
    h_norm(2,i) = vecnorm(constraint_unitary(x_hat(:,i), param),2);
end

figure("Name",window_title);
plot(param.sim.t,vecnorm(x-x_hat,2)); grid on;
title("Observer error measures");
hold on;
plot(param.sim.t, h_norm); grid on;
legend(["State error $\vert\vert x - \hat{x} \vert\vert_2$","$\vert\vert h_s \vert\vert_2$", "$\vert\vert h_u \vert\vert_2$"], ...
    "Location","northwest");
ylabel("Error");
xlabel("t in sec");
end

