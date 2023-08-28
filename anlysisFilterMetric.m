%[rp,rs,rpSum,rsSum,rpStd,rsStd,omega,poleUp1,zeroUp1,order]
function evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,AlgName)

if Problem.isPreDesign == 1
    AlgName = AlgName + "-Prior"
end

hf = abs(h);

%Cut-off frequency
temp1 = (hf - (1-rpUp)) > 0;
indx = find(temp1==1);
indx_start_omega = indx(end);
temp1 = (hf - rsUp) < 0;
indx = find(temp1==1);
indx_stop_omega = indx(1);

%bandpass cut-off frequency
evalResult.wp = w(indx_start_omega)/pi;
%bandstop cut-off frequency
evalResult.ws = w(indx_stop_omega)/pi;
%transition band width
evalResult.omega = abs(evalResult.wp - evalResult.ws);

indx_pass = 1:indx_start_omega;%Problem.indx_pass;
indx_stop = indx_stop_omega:Problem.fs;%Problem.indx_stop;

%transition band width
ideaH = Problem.desiredFilter_h';
errPassband = abs(hf(indx_pass) - ideaH(indx_pass));
errStopband = abs(hf(indx_stop) - ideaH(indx_stop));
evalResult.rpSum = sum(errPassband);
evalResult.rsSum = sum(errStopband);
evalResult.rp = max(errPassband);
evalResult.rs = max(errStopband);
evalResult.rpStd = std(errPassband);
evalResult.rsStd = std(errStopband);


%pole out of unit cycle
temp = roots(a);
Pole = abs(temp(find(abs(temp) >= 1.02)));
evalResult.poleUp1 = length(Pole);

%zero out of unit cycle
temp = roots(b);
Zore = abs(temp(find(abs(temp) >= 1.02)));
evalResult.zoreUp1 = length(Zore);

if (evalResult.poleUp1 + evalResult.zoreUp1)
    figure()
    Z_f = roots(b);
    P_f = roots(a);
    zplane(Z_f,P_f);
    legend('Zero','Pole');
    xlabel('Real Part');
    ylabel('Imaginary Part');
    title(AlgName);
    fprintf("%s:\r\n",AlgName);
    bb = abs(roots(b))
    aa = abs(roots(a))
end

evalResult.order = Problem.order;
end