function err = personObjFunc(sol,Problem)

[b,a] = sol2coef(sol,Problem.isVariableLength);

N = Problem.len;
out = filtfilt(b,a,Problem.sSig);

p = corrcoef(out,Problem.sSig);
err = 1 - p(1,2);

end