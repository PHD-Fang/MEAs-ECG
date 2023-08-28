function showProblem(Problem)   

N = Problem.len;
fs = Problem.fs;

figure();
t = 0:1/fs:(Problem.time-1/fs);
subplot(2,1,1);
plot(t,Problem.dSig);hold on
plot(t,Problem.sSig);
legend('raw','noise');
title('Wave')
xlabel('time(s)')
ylabel('ecg(mv)')

subplot(2,1,2);
df = fs/(N-1);
f = (0:N-1)*df;
DSIG = fft(Problem.dSig)/(N/2);
SSIG = fft(Problem.sSig)/(N/2);
plot(f(1:N/2),abs(DSIG(1:N/2)));hold on
plot(f(1:N/2),abs(SSIG(1:N/2)));
legend('raw','noise');
title('Single-Sided Amplitude Spectrum')
xlabel('f (Hz)')
ylabel('|Signal(f)|')

end