function plot_xk(xk, param)
%UNTITLED Summary of this function goes here

Sk = states_to_scattering_matrices(xk);

figure("Name","States", "Units", "normalized", "Position", [0.2 0.2 0.6 0.6]);
for i=1:param.sys.dim_S^2
    col = mod(i-1, param.sys.dim_S) + 1;
    row = ceil(i / param.sys.dim_S);

    subplot(param.sys.dim_S, param.sys.dim_S, i);
    plot(param.sim.t, real(squeeze(Sk(row,col,:))));
    grid on;
    hold on;
    plot(param.sim.t, imag(squeeze(Sk(row,col,:))));
    idx2 = (row+(col-1)*param.sys.dim_S + param.sys.dim_S^2);
    title("$S_{"+row+","+col+"} \equiv x_{"+(row+(col-1)*param.sys.dim_S)+"}+ i x_{"+idx2+"} $", "Interpreter","latex");
    if i == 1
    legend("$Re(x)$", "$Im(x)$","Interpreter","latex");
    end
    if(i>=param.sys.dim_S^2-param.sys.dim_S)
        xlabel("t in sec");
    end
end
end

