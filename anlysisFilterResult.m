clc
clear all
close all
addpath('../../../')
dataName = 'Function048low.mat';
load(dataName);

len = length(Function);

%[rp,rs,rpSum,rsSum,rpStd,rsStd,omega,poleUp1,zeroUp1,order]
% evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem)

rpUp = 0.1;
rsUp = 0.1;
fileName = 'filter048.txt';
fileID = fopen(fileName,'w');
fprintf(fileID,'filter048:\r\n');
fprintf(fileID,'alg\trp\trs\trpSum\trsSum\trpStd\trsStd\twp\tws\tomega\tpoleUp1\tzeroUp1\torder\r\n');

hfig = figure()
Problem = Function{2}.Problem;

%butter order = 6
b = Problem.b;
a = Problem.a;
[h,w] = freqz(b,a,Problem.fs);
evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,'butter');
fprintf(fileID,'%s\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%d\t%d\t%d\r\n', ...
    'buttor',evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
    evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
    evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);
figure(hfig),plot(w/pi,abs(h),'LineWidth',1);hold on

%cheby1 order = 6, rp=1dB
b = Problem.cb1;
a = Problem.ca1;
[h,w] = freqz(b,a,Problem.fs);
evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,'cheby01');
fprintf(fileID,'%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%d\t%d\t%d\r\n', ...
    'cheby01',evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
    evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
    evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);
figure(hfig),plot(w/pi,abs(h),'LineWidth',1);hold on

%cheby1 order = 6, rp=4dB
b = Problem.cb3;
a = Problem.ca3;
[h,w] = freqz(b,a,Problem.fs);
evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,'cheby04');
fprintf(fileID,'%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%d\t%d\t%d\r\n', ...
    'cheby04',evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
    evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
    evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);
figure(hfig),plot(w/pi,abs(h),'LineWidth',1);hold on

%cheby1 order = 6, rp=8dB
b = Problem.cb4;
a = Problem.ca4;
[h,w] = freqz(b,a,Problem.fs);
evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,'cheby08');
fprintf(fileID,'%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%d\t%d\t%d\r\n', ...
    'cheby08',evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
    evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
    evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);
figure(hfig),plot(w/pi,abs(h),'LineWidth',1);hold on

%ellip order = 6, rp=1dB, rs=30dB
b = Problem.cb2;
a = Problem.ca2;
[h,w] = freqz(b,a,Problem.fs);
evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,'ellip30');
fprintf(fileID,'%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%d\t%d\t%d\r\n', ...
    'ellip30',evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
    evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
    evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);
figure(hfig),plot(w/pi,abs(h),'LineWidth',1);hold on

%ellip order = 6, rp=1dB, rs=10dB
b = Problem.cb5;
a = Problem.ca5;
[h,w] = freqz(b,a,Problem.fs);
evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,'ellip10');
fprintf(fileID,'%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%d\t%d\t%d\r\n', ...
    'ellip10',evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
    evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
    evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);
figure(hfig),plot(w/pi,abs(h),'LineWidth',1);hold on

figure(hfig),plot(w/pi,Problem.desiredFilter_h,'LineWidth',2);hold on

% figure()
% Z_f = roots(Problem.b);
% P_f = roots(Problem.a);
% zplane(Z_f,P_f);

for Function_No = 1:1: 
    if(isempty(Function{Function_No}))
        continue;
    end
    
    algLen = Function{Function_No}.headInfo.algNum;
    Problem = Function{Function_No}.Problem;
    Alg = Function{Function_No}.headInfo.Alg;



    for o = 1:1:algLen
        [val,indx] = min(Function{Function_No}.bestScore(o,:));
        sol = Function{Function_No}.bestSol(o).data(indx,:);
        [b,a] = sol2coef(sol,Problem.isVariableLength);
        [h,w] = freqz(b,a,Problem.fs);
        evalResult = anlysisFilterMetric(b,a,h,w,rpUp,rsUp,Problem,Alg{o});
        fprintf(fileID,'%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%d\t%d\t%d\r\n', ...
            Alg{o},evalResult.rp,evalResult.rs,evalResult.rpSum,evalResult.rsSum, ...
            evalResult.rpStd,evalResult.rsStd,evalResult.wp,evalResult.ws,evalResult.omega, ...
            evalResult.poleUp1,evalResult.zoreUp1,evalResult.order);
        figure(hfig),plot(w/pi,abs(h),'LineWidth',1);hold on
    end


end
legend('buttor','cheby01','cheby04','cheby08' ...
    ,'ellip30','ellip30','idea' ...
    ,Alg{1},Alg{2},Alg{3},Alg{4},Alg{5} ...
    ,Alg{1},Alg{2},Alg{3},Alg{4},Alg{5})
fclose(fileID);
