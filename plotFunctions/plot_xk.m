function plot_xk(xk, param)
%UNTITLED Summary of this function goes here

Sk = states_to_scattering_matrices(xk);

figure("Name","States");
for i=1:param.sys.dim_S^2
    col = mod(i-1, param.sys.dim_S) + 1;
    row = ceil(i / param.sys.dim_S);

    subplot(param.sys.dim_S, param.sys.dim_S, i);
    plot(param.sim.t, real(squeeze(Sk(row,col,:))));
    grid on;
    hold on;
    plot(param.sim.t, imag(squeeze(Sk(row,col,:))));
    title("S("+row+","+col+")");
    legend("Re", "Im");
    if(i>=param.sys.dim_S^2-param.sys.dim_S)
        xlabel("t in sec");
    end
end
end

