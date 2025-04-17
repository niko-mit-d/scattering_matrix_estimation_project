%% Plot constraints for raw simulation data
h_true_norm = zeros(2, param.sim.dim_t);

for i=1:param.sim.dim_t
    [hu,~] = constraint_unitary(xk_true(:,i),param);
    [hs,~] = constraint_symmetry(xk_true(:,i),param);
    h_true_norm(:,i) = [norm(hs); norm(hu)];
end

figure("Name","Constraints of simulation data");
plot(param.sim.t, h_true_norm); grid on;
title("Constraint values of simulation data");
ylabel("Error");
xlabel("t in sec");
legend(["$\vert\vert h_s \vert\vert_2$", "$\vert\vert h_u \vert\vert_2$"], ...
    "Location","northwest");