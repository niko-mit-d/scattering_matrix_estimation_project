function h = constraint_combined(x,param)
%CONSTRAINT_COMBINED Calculates the constraint h = [hs, hu]
h = [constraint_symmetry(x, param);
     constraint_unitary(x,param)];
end

