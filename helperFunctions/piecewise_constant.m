function y = piecewise_constant(tau, uk, param)
%PIECEWISE_CONSTANT Calculates the active sensor for each timestep in
%param.sim.t from the measurement durations tau and schedule uk.
    switching_times = cumsum(tau);
    y = zeros(size(param.sim.t));

    y(param.sim.t < switching_times(1)) = uk(1);
    for i = 1:(length(switching_times) - 1)
        y(param.sim.t >= switching_times(i) & param.sim.t < switching_times(i+1)) = uk(i+1);
    end
    y(param.sim.t >= switching_times(end)) = uk(end);
end