%% System parameters
% --- adjust these
param.sys.dim_S = 3; % row/column dimensionality of S
param.sys.S0 = eye(param.sys.dim_S);
param.sys.sigma_y = 0.05; % standard deviation of noise added to measurement y
param.sys.sigma_S = 0.02; % standard deviation of random scattering matrix elements added to S each timestep
% ---

param.sys.n = 2 * param.sys.dim_S^2 - param.sys.dim_S*(param.sys.dim_S-1); % dimensionality of x
param.sys.p = param.sys.n; % dimensionality of v
param.sys.m = param.sys.n; % dimensionality of y
param.sys.k = param.sys.m; % dimensionlity of w
param.sys.x_0 = scattering_matrices_to_states(param.sys.S0, param);
%% Simulation parameters
% --- adjust these
param.sim.T = 2; % simulation duration in sec
param.sim.Ts = 2e-3; % sample time in sec
% ---

param.sim.t = 0:param.sim.Ts:param.sim.T; % time vector
param.sim.dim_t = length(param.sim.t);
%% Observer parameters
% --- adjust these
param.obs.K = [4.5843;.1159];
param.obs.x_hat_0 = param.sys.x_0; % same initial conditions for now!

% Kalman filter tuning
param.obs.P0 = eye(param.sys.dim_S);
% param.obs.Q = eye(param.obs.N); % not needed as no input available
param.obs.Ri = eye(2*param.sys.dim_S);
% ---

param.obs.A = zeros(param.sys.n); % observer only assumes noise is measured
param.obs.B = eye(param.sys.n);
param.obs.N = param.sys.dim_S; % number of sensors
param.obs.c = param.sys.dim_S*(param.sys.dim_S+1)/2; % dimensionality of constraints

param.obs.C = zeros(2*param.sys.dim_S, param.sys.n, param.obs.N);
% C(:,:,i) * x returns the i-th column of S
for i=1:param.obs.N
    for k=1:param.sys.dim_S
        % for each element in i-th column
        [idx_re, idx_im] = S_elem_to_idx(k,i,param);
        % real part
        param.obs.C(k,idx_re,i) = 1;
        % imaginary part
        param.obs.C(k+param.sys.dim_S,idx_im,i) = 1;
    end
end
clear i k idx_re idx_im;
param.obs.D = zeros(param.sys.n); % assuming there is no output noise
%% K Optimization parameters
% --- adjust these
param.opt.K0 = param.obs.K; % initial guess
param.opt.w_x = 1; % weight of state following error term
param.opt.w_h = 1; % weigh of constraint error term
% --- 
%% Scheduling optimization parameter
% --- adjust these
param.sch.P0 = diag(ones(param.sys.n,1));
% ---