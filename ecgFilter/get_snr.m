function [snr] = get_snr(noisesig,sig)

sigPower = sum(abs(sig).^2)/length(sig);  
noisePower = sum(abs(noisesig-sig).^2)/length(noisesig-sig);
snr = 10*log10(sigPower/noisePower);
end