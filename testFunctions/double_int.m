% continious time double integrator
% (https://en.wikipedia.org/wiki/Double_integrator)
sys_c = ss([0,1;0,0],[0;0],[1,0],0);
Ts = 0.5; % for example

% discrete time
sys_d = c2d(sys_c, Ts)