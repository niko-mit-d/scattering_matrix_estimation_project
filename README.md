# Scattering matrix estimation project

# Introduction
To run either use `main_sim.m` to simulate with real simulation data, or `main_random_walk.m` to use
randomly generated scattering matrices. 

`sys_spec` contains all modifiable specifications for the simulation, system, etc. 
`param` contains the full set of all parameters (independent and dependent) and should not be changed.

# Observers
`run_observer.m` implements the Lyapunov-based observer. 
`run_PM_kalman.m` implements the constrained Kalman filter using perfect measurements and double integrator as system model. 