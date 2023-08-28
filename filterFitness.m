%objFunc1: Mse of Filter Freqz
%objFunc2: Rapple in passband
%objFunc3: Rapple in Stopband
%objFunc4: Pole out of unit circle
%objFunc5: The order of filter.
%objFunc6: Signal mse in time domain.
%objFunc7: Signal mse in frequency domain.
%objFunc8: Signal person correlation coefficient.
function [fit,err] = filterFitness(sol,Problem)

objFunc = {'evalFilterFreqz','fftMseObjFunc','personObjFunc','filtMseObjFunc'};

err = zeros(8,1);
w = Problem.w;
if (sum(w(1:5))>0)
    err1 = evalFilterFreqz(sol,Problem);
end
err(1:5)=err1;

for i = 6:1:8
    if(w(i)>0)
        obj = str2func(objFunc(i-4));
        err(i) = obj(sol,Problem);
    end
end

if Problem.doSquare==1
    fit = Problem.w * (err./Problem.wcoef).^2;
else
    fit = Problem.w * err;
end
end