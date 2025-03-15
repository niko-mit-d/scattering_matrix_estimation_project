function [h, dhdx] = constraint_combined(x,param)
%CONSTRAINT_COMBINED Calculates the constraint h = [hs, hu]
[hs, dhsdx] = constraint_symmetry(x, param);
[hu, dhudx] = constraint_unitary(x,param);

h = [hs; hu];
dhdx = [dhsdx; dhudx];
end

