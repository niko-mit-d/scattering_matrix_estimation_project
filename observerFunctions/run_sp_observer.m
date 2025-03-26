function [x_hat, h_hat] = run_sp_observer(yk, tau, uk, param, options)
%RUN_OBSERVER Summary of this function goes here
arguments
    yk;
    tau;
    uk;
    param;
    options.printDetails logical = false;
end

x_hat = zeros(param.sys.n, param.sim.dim_t);
x_hat(:,1) = param.obs.x_hat_0; % initial condition
A = zeros(param.sys.n, 2);
k = piecewise_constant(tau, uk, param); % active sensor at time t
h_hat = zeros(param.obs.c, param.sim.dim_t);

for i=2:param.sim.dim_t
    A(:,1) = -(yk(:,i)-param.obs.C(:,:,k(i))*x_hat(:,i-1))'*param.obs.C(:,:,k(i));
    [h,dhdx] = constraint_combined(x_hat(:,i-1),param);
    A(:,2) = h'*dhdx;

    f = -pinv(A')*param.obs.K;
    x_hat(:,i) = x_hat(:,i-1)+f*param.sim.Ts;
    h_hat(:,i) = h;

    if (options.printDetails && mod(i,10)==0)
        fprintf("i=%d:\tA^T*f = [%f, %f]\n" + ...
            "\t||h||=%f\n", i, A(:,1)'*f, A(:,2)'*f, norm(h));
    end
end

end

