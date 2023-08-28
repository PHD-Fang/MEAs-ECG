function err = fftMseObjFunc(sol,Problem)

[b,a] = sol2coef(sol,Problem.isVariableLength);

N = Problem.len;
out = filtfilt(b,a,Problem.sSig);
DOUT = fft(out)/(N/2);

err = sum(abs(abs(DOUT) - abs(Problem.DSIG)));

end