%err1: Mse of Filter Freqz
%err2: Rapple in passband
%err3: Rapple in Stopband
%err4: Pole out of unit circle
%err5: The order of filter.
function err = evalFilterFreqz(sol,Problem)

if (0 == Problem.isVariableLength)
    [b,a] = sol2coef(sol,Problem.isVariableLength);   
    err5 = 0;
else
    [b,a,order] = sol2coef(sol,Problem.isVariableLength);  
    err5 = order/Problem.order;
end

[h,w] = freqz(b,a,Problem.fs);

hFilter = abs(h)';    
desiredFilter_h = Problem.desiredFilter_h;

err1 = sum(abs(hFilter-desiredFilter_h));


indx_pass = Problem.indx_pass;      
err2 = max(abs(abs(hFilter(indx_pass))-1));
% err2 = sum(abs(hFilter(indx_pass) - desiredFilter_h(indx_pass)));

indx_stop = Problem.indx_stop;  
err3 = max(hFilter(indx_stop));
% err3 = sum(abs(hFilter(indx_stop)));


if (sum(isnan(a)) + sum(isinf(a)))
    a
    err4 = 0;
else
    Pole = roots(a);
    T1 = sum(abs(Pole(find(abs(Pole) >= 1))));
    T2 = sum(abs(Pole));
    if(0==T2)
        err4 = 0;
    else
        err4 = T1/T2;
    end
%     if T1>0, err4 = 1000;end
%     Zore = roots(b);
%     T1 = sum(abs(Zore(find(abs(Zore) >= 1))));
%     if T1>0, err4 = 1000;end
end
err = [err1,err2,err3,err4,err5]';
end