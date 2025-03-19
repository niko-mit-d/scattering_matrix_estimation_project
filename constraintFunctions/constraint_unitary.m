function [hu, dhudx] = constraint_unitary(x,param)
%CONSTRAINT_UNITARY Implements the symmetry constraint hu
arguments
    x (:,1);
    param;
end
hu = zeros(param.sys.dim_S*(param.sys.dim_S+1)/2, 1);
dhudx = zeros(size(hu,1), param.sys.n);

% The constraint is calculated after transformation to matrices. Easier to
% understand this way.
% S = states_to_scattering_matrices(x);
% S_hermetian = pagectranspose(S); % does conjugate tranpose on each S(:,:,i) matrix 
% hu_mat = pagemtimes(S_hermetian,S) - eye(param.sys.dim_S);

index = 1;
for k=0:param.sys.dim_S-1
    for l=k:param.sys.dim_S-1
        % Take only differences from upper traingle matrix with main
        % diagonal.
        for p=1:param.sys.dim_S
            hu(index) = hu(index) + x(p+k*param.sys.dim_S)*x(p+l*param.sys.dim_S) + ...
                x(param.sys.n/2+p+k*param.sys.dim_S)*x(param.sys.n/2+p+l*param.sys.dim_S);

            dhudx(index,p+k*param.sys.dim_S) = dhudx(index,p+k*param.sys.dim_S) + x(p+l*param.sys.dim_S);
            dhudx(index,p+l*param.sys.dim_S) = dhudx(index,p+l*param.sys.dim_S) + x(p+k*param.sys.dim_S);
            dhudx(index,end/2+p+k*param.sys.dim_S) = dhudx(index,end/2+p+k*param.sys.dim_S) + x(end/2+p+l*param.sys.dim_S);
            dhudx(index,end/2+p+l*param.sys.dim_S) = dhudx(index,end/2+p+l*param.sys.dim_S) + x(end/2+p+k*param.sys.dim_S);
        end
        if k==l
            hu(index) = hu(index) - 1;
        end
        index = index + 1;
    end
end
end

