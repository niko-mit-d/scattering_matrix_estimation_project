function [x_hat, h_hat] = run_observer2(yk, tau, uk, param, Ki, options)
% RUN_OBSERVER2 overload of run_observer, where K parameters can be set
% explicitly for optimization pruposes
arguments
    yk;
    tau;
    uk;
    param;
    Ki;
    options.printDetails logical = false;
end

param.obs.K = Ki;
[x_hat, h_hat] = run_observer(yk, tau, uk, param, options);

end

