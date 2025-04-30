function [x_hat, h_hat] = run_observer(yk, tau, uk, param, method)
switch(method)
    case "lyapunov"
        [x_hat, h_hat] = run_lyapunov_observer(yk, tau, uk, param, "printDetails", false);
    case "PM_kalman"
        [x_hat, h_hat] = run_PM_kalman(yk, tau, uk, param);
    case "pure_kalman"
        [x_hat, h_hat] = run_pure_kalman(yk, tau, uk, param);
    case "pure_kalman_integrator"
        [x_hat, h_hat, ~] = run_pure_kalman_integrator(yk, tau, uk, param);
    otherwise
        fprintf("Unknown method!\n");
end
end

