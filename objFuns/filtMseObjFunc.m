function err = filtMseObjFunc(sol,Problem)

[b,a] = sol2coef(sol,Problem.isVariableLength);

N = Problem.len;
out = filtfilt(b,a,Problem.sSig);

err = sum((out - Problem.sSig).^2)/Problem.len;

end