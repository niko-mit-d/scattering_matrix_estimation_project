function param = get_parameters(sys_spec)
% GET_PARAMETERS defines all other parameters dependent of sys_spec
param = sys_spec;

%% System parameters
param.sys.n = 2 * param.sys.dim_S^2 - param.sys.dim_S*(param.sys.dim_S-1); % dimensionality of x
param.sys.p = param.sys.n; % dimensionality of v
param.sys.m = param.sys.n; % dimensionality of y
param.sys.k = param.sys.m; % dimensionlity of w
param.sys.x_0 = scattering_matrices_to_states(param.sys.S0, param);

%% Simulation parameters
param.sim.t = linspace(0,param.sim.T, param.sim.dim_t);
param.sim.Ts = param.sim.t(2) - param.sim.t(1); % sample time in sec

%% Observer parameters
param.obs.x_hat_0 = scattering_matrices_to_states(param.obs.S0_hat, param);

param.obs.A = zeros(param.sys.n); % observer only assumes noise is measured
param.obs.B = eye(param.sys.n);
param.obs.N = param.sys.dim_S; % number of sensors
param.obs.c = param.sys.dim_S*(param.sys.dim_S+1)/2; % dimensionality of constraints
param.obs.dim_y = 2*param.sys.dim_S;

param.obs.C = zeros(param.obs.dim_y, param.sys.n, param.obs.N);
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
param.obs.D = zeros(param.sys.n); % assuming there is no output noise

%% Kalman filter parameters for double integrator model
% For model-free Kalman filter (run_pure_kalman.m), the tuning matrices
% need to be set inside the function to keep param struct tidy

param.kal.x_hat_0 = [param.sys.x_0; zeros(param.sys.n,1)]; % same initial conditions for now!
% discrete time implementation of double integrator
% derived from testFunctions/double_int.m
param.kal.F = [eye(param.sys.n), param.sim.Ts*eye(param.sys.n); zeros(param.sys.n), eye(param.sys.n)];
param.kal.C = zeros(param.obs.dim_y, 2*param.sys.n, param.obs.N);
for i=1:param.obs.N
    param.kal.C(:,:,i) = [param.obs.C(:,:,i), zeros(param.obs.dim_y, param.sys.n)];
end
%% K Optimization parameters
% given by sys_spec
%% Scheduling optimization parameter
% given by sys_spec
end

