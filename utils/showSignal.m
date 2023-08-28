function showSignal(sol,Problem,name)

n = size(sol,2);
blen = floor(n/2);
b = sol(1:blen);
a = [1,sol(blen+1:n)];

out = filtfilt(b,a,Problem.sSig);

figure()
subplot(2,1,1);
plot(out);hold on
plot(Problem.dSig);
legend('design','idea');
title(name);
subplot(2,1,2);
ecgFFT = fft(Problem.dSig);
P2 = abs(ecgFFT/Problem.len);
P1 = P2(1:Problem.len/2+1);
P1(2:end-1) = 2*P1(2:end-1);

sSigFFT = fft(out);
sP2 = abs(sSigFFT/Problem.len);
sP1 = sP2(1:Problem.len/2+1);
sP1(2:end-1) = 2*sP1(2:end-1);

f = Problem.fs*(0:(Problem.len/2))/Problem.len;
plot(f,P1);hold on
plot(f,sP1);
legend('raw','filter')
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
set(gca,'FontSize',24,'Fontname','Times New Roman');

end