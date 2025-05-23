clc; clear all;
addpath(genpath("."));
set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

%% System specification
% sys_spec is a subset from param consisting of independent, freely
% chooseable specifications.
sys_spec.sys.dim_S = 3; % dimensionality of S 
sys_spec.sys.n = 2 * sys_spec.sys.dim_S^2 - sys_spec.sys.dim_S*(sys_spec.sys.dim_S-1);% dim. of state vector

% adapt these
% ---
sys_spec.sys.sigma_y = 0.0; % measurement noise
sys_spec.sys.sigma_S = 0.03; % noise on S

sys_spec.obs.K = [0.0206; 0.0020]; % Lyapunov observer coeffs
sys_spec.obs.S0_hat = eye(sys_spec.sys.dim_S); % initial S for observer

% Kalman filter tuning
sys_spec.kal.P0 = 1*eye(2*sys_spec.sys.n);
sys_spec.kal.Q = 1*eye(2*sys_spec.sys.n);
% Last half of entries is chosen much smaller, as these are "perfect
% measurements" with tiny covariance
sys_spec.kal.R = 1*diag([1 1 1 1 1 1 0.01 0.01 0.01 0.01 0.01 0.01]);

% Optimization settings
sys_spec.opt.K0 = sys_spec.obs.K; % initial guess
sys_spec.opt.w_x = 2; % weight of state following error term
sys_spec.opt.w_h = 1; % weigh of constraint error term
% ---

%% Get scattering matrix from simulation data 
% Load simulation data (S matrix and time vector)
data_path = "simdata_1.mat";
load("simulation_mat_data/" + data_path)
% permutation due to different orders being used in sim data
Sk_true = permute(Sk, [2 3 1]);
% add noise
Sk_noise = Sk_true + sys_spec.sys.sigma_S*(randn(size(Sk_true)) + 1i*randn(size(Sk_true)));
% time vector not compatible size for some reason! it is shortened to fit
% Other simulations seem to use sample time of 1e-7, so this is assumed
tk = tk(1:size(Sk_true,3));

sys_spec.sys.S0 = eye(sys_spec.sys.dim_S);
sys_spec.sim.T = tk(end);
sys_spec.sim.dim_t = length(tk);
param = get_parameters(sys_spec);

xk = scattering_matrices_to_states(Sk_noise, param);
xk_true = scattering_matrices_to_states(Sk_true, param);

fprintf("Data path: " + data_path + "\nSample time: %.2e s\nSimulation duration: %.2e s\n", param.sim.Ts, param.sim.T);

%% Calculate sensor schedule
% cycling through all sensor
samples_per_sensor = 5;
cycles = round(param.sim.T/param.sim.Ts/param.sys.dim_S/samples_per_sensor);
tau = param.sim.T/(param.obs.N*cycles)*ones(1,param.obs.N*cycles);
uk = repmat(1:param.obs.N,1,cycles);

yk = evaluate_y(xk, tau, uk, param);
% plot_schedule(tau, uk, param);
% plot_xk_overlayed_with_yk(xk, yk, param);
fprintf("Sensor schedule: %.2f samples per sensor\n", tau(1)/param.sim.Ts);

%% Optimization to find suiting Ki parameters
opt_technique = -1;

switch opt_technique
    case 0
        % Global optimization using PSO
        pso_options = optimoptions("particleswarm", "Display", "iter");
        [K, Lval] = particleswarm(@(K)calculate_performance(xk_true, yk, tau, uk, param, K'), 2, [0.015;0], [0.025;0.002], pso_options);
        param.obs.K=K';
    case 1
        % Global optimization only K1 using PSO
        pso_options = optimoptions("particleswarm", "Display", "iter");
        [K1, Lval] = particleswarm(@(K)calculate_performance(xk_true, yk, tau, uk, param, [K; param.opt.K0(2)]), 1, 0, 1, pso_options);
        param.obs.K(1) = K1;
        param.obs.K(2) = param.opt.K0(2);
    case 2
        % Optimization using fmincon
        opt_options = optimoptions("fmincon", "StepTolerance", 1e-10);
        [K, Lval] = fmincon(@(K)calculate_performance(xk_true, yk, tau, uk, param, K), param.opt.K0, [],[],[],[],[0;0.001],[1,0.1],[],opt_options);
        param.obs.K = K;
    case 3
        % optimize only K1 using fmincon
        opt_options = optimoptions("fmincon", "StepTolerance", 1e-10);
        [K1, Lval] = fmincon(@(K1)calculate_performance(xk_true, yk, tau, uk, param, [K1;param.opt.K0(2)]), param.opt.K0(1), [],[],[],[],0,1,[],opt_options);
        param.obs.K(1) = K1;
        param.obs.K(2) = param.opt.K0(2);
    otherwise
        % default parameters from sys_spec
end

%% Run observer

% Choose observer method here
method = "lyapunov";
% method = "PM_kalman";   % PM ... perfect measurement
% method = "pure_kalman";
% method = "pure_kalman_integrator";

[x_hat, h_hat] = run_observer(yk, tau, uk, param, method);

plot_performance(xk,x_hat,param, "Optimized parameters");
plot_observer_results_with_noise(x_hat, xk, xk_true, param);
fprintf("Optimized K vector: [%.4f; %.4f]\n", param.obs.K(1), param.obs.K(2));