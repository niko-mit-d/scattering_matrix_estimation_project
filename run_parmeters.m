%% System parameters
param.sys.dim_S = 3; % row/column dimensionality of S
param.sys.S0 = eye(param.sys.dim_S);

param.sys.n = 2 * param.sys.dim_S^2; % dimensionality of x
param.sys.p = param.sys.n; % dimensionality of v
param.sys.m = param.sys.n; % dimensionality of y
param.sys.k = param.sys.m; % dimensionlity of w
param.sys.x_0 = scattering_matrices_to_states(param.sys.S0);

%% Simulation parameters
param.sim.T = 1; % simulation duration in sec
param.sim.Ts = 5e-3; % sample time in sec
param.sim.t = 0:param.sim.Ts:param.sim.T; % time vector
param.sim.dim_t = length(param.sim.t);

%% Observer parameters
param.obs.K = [5;.1];
param.obs.x_hat_0 = param.sys.x_0; % same initial conditions for now!

param.obs.A = zeros(param.sys.n); % observer only assumes noise is measured
param.obs.B = eye(param.sys.n);
param.obs.N = param.sys.dim_S; % number of sensors

param.obs.C = zeros(2*param.sys.dim_S, 2*param.sys.dim_S^2, param.obs.N);
for i=1:param.obs.N
    param.obs.C(1:param.sys.dim_S,param.sys.dim_S*(i-1)+1:param.sys.dim_S*i,i) = eye(param.sys.dim_S);
    param.obs.C(param.sys.dim_S+1:end,param.sys.dim_S*(i+param.obs.N-1)+1:param.sys.dim_S*(i+param.obs.N),i) = eye(param.sys.dim_S);
end
param.obs.D = zeros(param.sys.n); % assuming there is no output noise

%% Scheduling optimization parameter
param.sch.P0 = diag(ones(param.sys.n,1));