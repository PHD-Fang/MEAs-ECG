close all

A_snr = [0.1,0.2,0.3,0.4,0.5,0.8,1,1.3,1.5,1.7,2,2.5];
B_snr = [15,14,13,12,11,10,9,8,7,6,5,4];
for snr_no = 1:12
    snr_name = ['snr',num2str(snr_no)];
    num = 1;
    num_r = 0;
    num_rr = 0;
for i = 3:4:187

opath = 'D:\论文\ecgFilter\mit-bih-arrhythmia-database-1.0.01(1)\';
list = dir(opath);

A = A_snr(snr_no);%frequency noise
B = B_snr(snr_no);%GWN

oder = 4; %filter oder
fc = 0.48;

Problem.fs=360;
fs = Problem.fs;
Problem.time = 20;
Problem.len = Problem.fs*Problem.time;
Problem.wp = [36,360]/1000;
Problem.start = 1;
Problem.stop = Problem.fs*20 + Problem.len - 1;
array = Problem.start:Problem.stop;

%% load data
a = strcat(list(i).name);
b = strcat(list(i+1).name);
c = strcat(list(i+2).name);
ecg0000 = loaddata(a,b,c,opath);

ecg = ecg0000(1:Problem.len)';

clear ecg0000;

%% add noise
t = 0:1/fs:(Problem.time-1/fs);
ecg1 = awgn(ecg,B,'measured');
noise2 = A*cos(2*pi*90*t-pi*30/180) + A*cos(2*pi*100*t+pi*90/180);%
noiseEcg = ecg1 + noise2;

figure('visible','off')
subplot(2,1,1)
plot(t,ecg(1,:));hold on
plot(t,noiseEcg(1,:));hold on
legend('raw','noise');
title('raw data')
subplot(2,1,2)
N = size(ecg,2);% Problem.len;
df = Problem.fs/(N-1);
f = (0:N-1)*df;
DSIG = fft(ecg(1:N))/(N/2);
SSIG = fft(noiseEcg(1:N))/(N/2);
plot(f(1:N/2),abs(DSIG(1:N/2)));hold on
plot(f(1:N/2),abs(SSIG(1:N/2)));
legend('raw','nosie');
title('raw fft')
%% load filter
load("Function4order048low.mat");
o = 4;
Function_No = 2;
[val,indx] = min(Function{Function_No}.bestScore(o,:));
sol = Function{Function_No}.bestSol(o).data(indx,:);
n = size(sol,2);
blen = round(n/2);
b = sol(1:blen);
a = [1,sol(blen+1:n)];
dataOut01 = filtfilt(b,a,noiseEcg);
[h1,w1] = freqz(b,a);

%% butter
[b,a] = butter(oder,fc,"low");
[h2,w2] = freqz(b,a);
dataOut02 = filtfilt(b,a,noiseEcg);
%% cheby01
[b,a] = cheby1(oder,1,fc,"low");
[h3,w3] = freqz(b,a);
dataOut03 = filtfilt(b,a,noiseEcg);
%% cheby04
[b,a] = cheby1(oder,4,fc,"low");
[h4,w4] = freqz(b,a);
dataOut04 = filtfilt(b,a,noiseEcg);
%% cheby08
[b,a] = cheby1(oder,8,fc,"low");
[h5,w5] = freqz(b,a);
dataOut05 = filtfilt(b,a,noiseEcg);


%% medfilt
dataOut01= medfilt1(dataOut01,10);
dataOut02= medfilt1(dataOut02,10);
dataOut03= medfilt1(dataOut03,10);
dataOut04= medfilt1(dataOut04,10);
dataOut05= medfilt1(dataOut05,10);

figure('visible','off')
plot(w1/pi,abs(h1));hold on
plot(w2/pi,abs(h2));hold on
plot(w3/pi,abs(h3));hold on
plot(w4/pi,abs(h4));hold on
plot(w5/pi,abs(h5));hold on
legend('design','butter','cheby01','cheby04','cheby08');

FFTOUT01 = fft(dataOut01)/(N/2);
FFTOUT02 = fft(dataOut02)/(N/2);
FFTOUT03 = fft(dataOut03)/(N/2);
FFTOUT04 = fft(dataOut04)/(N/2);
FFTOUT05 = fft(dataOut05)/(N/2);

figure('visible','off')
subplot(2,1,1);
plot(t,ecg(1,:));hold on
plot(t,dataOut01(1,:));hold on
plot(t,dataOut02);hold on
plot(t,dataOut03);hold on
plot(t,dataOut04);hold on
plot(t,dataOut05);hold on
legend('raw','design','butter','cheby01','cheby04','cheby08');
subplot(2,1,2);
plot(f(1:N/2),abs(SSIG(1:N/2)));hold on
plot(2*f(1:N/2)/fs,abs(FFTOUT01(1:N/2)));hold on
plot(2*f(1:N/2)/fs,abs(FFTOUT02(1:N/2)));hold on
plot(2*f(1:N/2)/fs,abs(FFTOUT03(1:N/2)));hold on
plot(2*f(1:N/2)/fs,abs(FFTOUT04(1:N/2)));hold on
plot(2*f(1:N/2)/fs,abs(FFTOUT05(1:N/2)));hold on
legend('raw','design','butter','cheby01','cheby04','cheby08');
title('2')


%% snr
SNRtime = get_snr(noiseEcg,ecg);
SNR1time = get_snr(dataOut01,ecg);
SNR2time = get_snr(dataOut02,ecg);
SNR3time = get_snr(dataOut03,ecg);
SNR4time = get_snr(dataOut04,ecg);
SNR5time = get_snr(dataOut05,ecg);

%% correlation
r1 = corrcoef(ecg,dataOut01);
r2 = corrcoef(ecg,dataOut02);
r3 = corrcoef(ecg,dataOut03);
r4 = corrcoef(ecg,dataOut04);
r5 = corrcoef(ecg,dataOut05);

%% waveform
R_val=[];R_val1=[];R_val2=[];R_val3=[];R_val4=[];R_val5=[];
RR = [];RR1 = [];RR2 = [];RR3 = [];RR4 = [];RR5 = [];

[R_val,R_loc,RR] = getPQRST(ecg,fs,0.2);%rawdata
[R_val1,R_loc1,RR1] = getPQRST2(dataOut01,fs,R_loc);%design
[R_val2,R_loc2,RR2] = getPQRST2(dataOut02,fs,R_loc);%butter
[R_val3,R_loc3,RR3] = getPQRST2(dataOut03,fs,R_loc);%cheby01
[R_val4,R_loc4,RR4] = getPQRST2(dataOut04,fs,R_loc);%cheby04
[R_val5,R_loc5,RR5] = getPQRST2(dataOut05,fs,R_loc);%cheby08

%R peak correlation
R1 = corrcoef(R_val,R_val1);
R2 = corrcoef(R_val,R_val2);
R3 = corrcoef(R_val,R_val3);
R4 = corrcoef(R_val,R_val4);
R5 = corrcoef(R_val,R_val5);
rr1 = corrcoef(RR,RR1);
rr2 = corrcoef(RR,RR2);
rr3 = corrcoef(RR,RR3);
rr4 = corrcoef(RR,RR4);
rr5 = corrcoef(RR,RR5);

%% result
result.snrtime(num,1) = SNRtime;%snr
result.snrtime(num,2) = SNR1time;
result.snrtime(num,3) = SNR2time;
result.snrtime(num,4) = SNR3time;
result.snrtime(num,5) = SNR4time;
result.snrtime(num,6) = SNR5time;
result.meansnrtime = mean(result.snrtime(:,1));
result.cor(num,1) = r1(1,2);%correlation
result.cor(num,2) = r2(1,2);
result.cor(num,3) = r3(1,2);
result.cor(num,4) = r4(1,2);
result.cor(num,5) = r5(1,2);

result.r(num_r+1:num_r+length(R_val),1) = R_val';%R peak
result.r(num_r+1:num_r+length(R_val1),2) = R_val1';
result.r(num_r+1:num_r+length(R_val2),3) = R_val2';
result.r(num_r+1:num_r+length(R_val3),4) = R_val3';
result.r(num_r+1:num_r+length(R_val4),5) = R_val4';
result.r(num_r+1:num_r+length(R_val5),6) = R_val5';

result.rr(num_rr+1:num_rr+length(RR),1) = RR';%RR interval
result.rr(num_rr+1:num_rr+length(RR1),2) = RR1';
result.rr(num_rr+1:num_rr+length(RR2),3) = RR2';
result.rr(num_rr+1:num_rr+length(RR3),4) = RR3';
result.rr(num_rr+1:num_rr+length(RR4),5) = RR4';
result.rr(num_rr+1:num_rr+length(RR5),6) = RR5';

result.r_ratio(num,1) = mean(abs((R_val-R_val1))./R_val);%R peak change ratio
result.r_ratio(num,2) = mean(abs((R_val-R_val2))./R_val);
result.r_ratio(num,3) = mean(abs((R_val-R_val3))./R_val);
result.r_ratio(num,4) = mean(abs((R_val-R_val4))./R_val);
result.r_ratio(num,5) = mean(abs((R_val-R_val5))./R_val);

result.rr_ratio(num,1) = mean(abs((RR-RR1))./RR);%RR interval change ratio
result.rr_ratio(num,2) = mean(abs((RR-RR2))./RR);
result.rr_ratio(num,3) = mean(abs((RR-RR3))./RR);
result.rr_ratio(num,4) = mean(abs((RR-RR4))./RR);
result.rr_ratio(num,5) = mean(abs((RR-RR5))./RR);

result.r_cor(num,1) = R1(1,2);%R peak correlation
result.r_cor(num,2) = R2(1,2);
result.r_cor(num,3) = R3(1,2);
result.r_cor(num,4) = R4(1,2);
result.r_cor(num,5) = R5(1,2);

result.rr_cor(num,1) = rr1(1,2);%RR interval correlation
result.rr_cor(num,2) = rr2(1,2);
result.rr_cor(num,3) = rr3(1,2);
result.rr_cor(num,4) = rr4(1,2);
result.rr_cor(num,5) = rr5(1,2);

%% save figuer and result

num = num+1;
num_r = num_r+length(R_val);
num_rr = num_rr+length(RR);

close all
end
RESULT.(snr_name) = result;
end
% save('RESULT_Function4order048low_4.mat','RESULT');
