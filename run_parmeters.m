%% Dimensionalities
param_sys.dim_S = 3; % row/column dimensionality of S

param_sys.n = 2 * param_sys.dim_S^2; % dimensionality of x
param_sys.p = param_sys.n; % dimensionality of v
param_sys.m = param_sys.n; % dimensionality of y
param_sys.k = param_sys.m; % dimensionlity of w

%% Simulation parameters
param_sim.T = 1; % simulation duration in sec
param_sim.Ts = 1e-3; % sample time in sec
param_sim.t = 0:param_sim.Ts:param_sim.T; % time vector
param_sim.dim_t = length(param_sim.t);

%% Scheduling optimization parameter
param_opt.P0 = diag(ones(param_sys.n,1));