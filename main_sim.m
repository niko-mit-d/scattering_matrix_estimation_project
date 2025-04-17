clc; clear all;
addpath(genpath("."));
set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

%% System specification
% sys_spec is a subset from param consisting of independent, freely
% chooseable specifications.
sys_spec.sys.dim_S = 3;
sys_spec.sys.n = 2 * sys_spec.sys.dim_S^2 - sys_spec.sys.dim_S*(sys_spec.sys.dim_S-1);

% adapt these
% ---
sys_spec.sys.sigma_y = 0.05;
sys_spec.sys.sigma_S = 0.0001;

sys_spec.obs.K = [4.5e5;.1159];
sys_spec.obs.S0_hat = eye(sys_spec.sys.dim_S); % same initial conditions for now!
% Kalman filter tuning
sys_spec.obs.P0 = eye(sys_spec.sys.dim_S);
% param.obs.Q = eye(param.obs.N); % not needed as no input available
sys_spec.obs.Ri = eye(2*sys_spec.sys.dim_S);

sys_spec.kal.P0 = .1*eye(2*sys_spec.sys.n);

sys_spec.kal.Q = .01*eye(2*sys_spec.sys.n);
% param.kal.R = 1*eye(param.obs.dim_y + param.obs.c);
sys_spec.kal.R = 1*diag([1 1 1 1 1 1 0.01 0.01 0.01 0.01 0.01 0.01]);

sys_spec.opt.K0 = sys_spec.obs.K; % initial guess
sys_spec.opt.w_x = 1; % weight of state following error term
sys_spec.opt.w_h = 1; % weigh of constraint error term

sys_spec.sch.P0 = diag(ones(sys_spec.sys.n,1));
% ---

%% Get scattering matrix from simulation data 
% Load simulation data (S matrix and time vector)
load("simulation_mat_data/simdata_1.mat")
% permutation due to different orders being usedx
Sk_true = permute(Sk, [2 3 1]);
% add noise
Sk = Sk_true + 0;
% time vector not compatible size. it is shortened to fit
% Other simulations seem to use sample time of 1e-7, so this is assumed
tk = tk(1:size(Sk,3));

sys_spec.sys.S0 = eye(sys_spec.sys.dim_S);
sys_spec.sim.T = tk(end);
sys_spec.sim.dim_t = length(tk);
param = get_parameters(sys_spec);

xk = scattering_matrices_to_states(Sk, param);
xk_true = scattering_matrices_to_states(Sk_true, param);

%% Calculate sensor schedule
% cycling through all sensor
cycles = 110;
tau = param.sim.T/(param.obs.N*cycles)*ones(1,param.obs.N*cycles);
uk = repmat(1:param.obs.N,1,cycles);
fprintf("Sensor schedule: %.2f samples per sensor\n", tau(1)/param.sim.Ts);

yk = evaluate_y(xk, tau, uk, param);
% plot_schedule(tau, uk, param);
% plot_xk_overlayed_with_yk(xk, yk, param);

%% Optimization to find suiting Ki parameters
opt_technique = -1;

switch opt_technique
    case 0
        % Global optimization using PSO
        pso_options = optimoptions("particleswarm", "Display", "iter");
        [K, Lval] = particleswarm(@(K)calculate_performance(xk_true, yk, tau, uk, param, K'), 2, [1e5;0], [1e7;20], pso_options);
        K=K';
    case 1
        % Global optimization only K1 using PSO
        pso_options = optimoptions("particleswarm", "Display", "iter");
        [K1, Lval] = particleswarm(@(K)calculate_performance(xk_true, yk, tau, uk, param, [K; param.opt.K0(2)]), 1, 1, 20, pso_options);
        param.obs.K(1) = K1;
        param.obs.K(2) = param.opt.K0(2);
    case 2
        % Optimization using fmincon
        opt_options = optimoptions("fmincon", "StepTolerance", 1e-10);
        [K, Lval] = fmincon(@(K)calculate_performance(xk_true, yk, tau, uk, param, K), param.opt.K0, [],[],[],[],[1e6;0.001],[Inf,Inf],[],opt_options);
        param.obs.K = K;
    case 3
        % optimize only K1 using fmincon
        opt_options = optimoptions("fmincon", "StepTolerance", 1e-10);
        [K1, Lval] = fmincon(@(K1)calculate_performance(xk_true, yk, tau, uk, param, [K1;param.opt.K0(2)]), param.opt.K0(1), [],[],[],[],3,Inf,[],opt_options);
        param.obs.K(1) = K1;
        param.obs.K(2) = param.opt.K0(2);
    otherwise
        % default parameters
        % take from run_parameters
end

[x_hat, h_hat] = run_observer(yk, tau, uk, param, "printDetails", false);
% [x_hat, h_hat] = run_PM_kalman(yk, tau, uk, param);
plot_performance(xk,x_hat,param, "Optimized parameters");
% plot_observer_results(x_hat, xk, param);
plot_observer_results_with_noise(x_hat, xk, xk_true, param);
fprintf("Loss: %.2f\n", calculate_performance(xk_true, yk, tau, uk, param, param.obs.K));
fprintf("Optimized K vector: [%.2f; %.2f]\n", param.obs.K(1), param.obs.K(2));