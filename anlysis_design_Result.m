clc
clear all
close all
addpath('objFuns\')
fileName = 'filter048_4order-1-0-0-1.txt';
fileID = fopen(fileName,'w');
fprintf(fileID,'filter048:\r\n');
fprintf(fileID,'alg\trp\trs\trpSum\trsSum\trpStd\trsStd\twp\tws\tomega\tpoleUp1\tzeroUp1\torder\r\n');

Function_No = 2;
wp=0.452;
ws=0.5;
rp=-mag2db(0.9);
rs=-mag2db(0.1);
rpUp = 0.1;
rsUp = 0.1;
load("Result\Function4order048low.mat");%Problem4
Problem = Function{Function_No}.Problem;

b = Problem.b;
a = Problem.a;
[h,w] = freqz(b,a,Problem.fs);
evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,'buttor');
fprintf(fileID,'%s\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%d\t%d\t%d\r\n', ...
    'buttor',evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
    evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
    evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);

b = Problem.cb1;
a = Problem.ca1;
[h,w] = freqz(b,a,Problem.fs);
evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,'cheby1');
fprintf(fileID,'%s\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%d\t%d\t%d\r\n', ...
    'cheby1',evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
    evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
    evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);

b = Problem.cb3;
a = Problem.ca3;
[h,w] = freqz(b,a,Problem.fs);
evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,'cheby4');
fprintf(fileID,'%s\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%d\t%d\t%d\r\n', ...
    'cheby4',evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
    evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
    evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);

b = Problem.cb4;
a = Problem.ca4;
[h,w] = freqz(b,a,Problem.fs);
evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,'cheby8');
fprintf(fileID,'%s\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%d\t%d\t%d\r\n', ...
    'cheby8',evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
    evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
    evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);

b = Problem.cb2;
a = Problem.ca2;
[h,w] = freqz(b,a,Problem.fs);
evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,'ellip30');
fprintf(fileID,'%s\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%d\t%d\t%d\r\n', ...
    'ellip30',evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
    evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
    evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);
b = Problem.cb5;
a = Problem.ca5;
[h,w] = freqz(b,a,Problem.fs);
evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,'ellip10');
fprintf(fileID,'%s\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%d\t%d\t%d\r\n', ...
    'ellip10',evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
    evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
    evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);


[h,w] = freqz(Problem.b,Problem.a,Problem.fs);
plot(w/pi,abs(h),'LineWidth',1);hold on
[h,w] = freqz(Problem.cb1,Problem.ca1,Problem.fs);
plot(w/pi,abs(h),'LineWidth',1);hold on
[h,w] = freqz(Problem.cb3,Problem.ca3,Problem.fs);
plot(w/pi,abs(h),'LineWidth',1);hold on
[h,w] = freqz(Problem.cb4,Problem.ca4,Problem.fs);
plot(w/pi,abs(h),'LineWidth',1);hold on
[h,w] = freqz(Problem.cb2,Problem.ca2,Problem.fs);
plot(w/pi,abs(h),'LineWidth',1);hold on
[h,w] = freqz(Problem.cb5,Problem.ca5,Problem.fs);
plot(w/pi,abs(h),'LineWidth',1);hold on

bestAlg = 4;
clear Problem
load("Result\Function4order048low.mat");%Problem4
Problem = Function{Function_No}.Problem;
% [val,indx] = min(Function{Function_No}.bestScore(bestAlg,:));
% sol = Function{Function_No}.bestSol(bestAlg).data(indx,:);
% [b,a] = sol2coef(sol,Problem.isVariableLength);



algName = Function{Function_No}.headInfo.Alg;
algNum = Function{Function_No}.headInfo.algNum;
for iAlg = 1:1:algNum
    [val,indx] = min(Function{Function_No}.bestScore(iAlg,:));
    sol = Function{Function_No}.bestSol(iAlg).data(indx,:);
    [b,a] = sol2coef(sol,Problem.isVariableLength);
    
    [h,w] = freqz(b,a,Problem.fs);
    plot(w/pi,abs(h),'LineWidth',1);hold on

    [h,w] = freqz(b,a,Problem.fs);
    evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,algName{iAlg});
    fprintf(fileID,'%s\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%d\t%d\t%d\r\n', ...
        algName{iAlg},evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
        evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
        evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);
end

plot(w/pi,Problem.desiredFilter_h)

legend('butter','cheby1','cheby4','cheby8','ellip30','ellip10','ABC','PSO','SOS','SSA','WOA','idea')

fclose(fileID);





