function [R_val,R_loc,RR] = getPQRST(data,fs,height)

%% baseline
fmaxd_1 = 5;
fmaxn_1 = fmaxd_1/(fs/2);
[B,A] = butter(1,fmaxn_1,'low');
ecg_low=filtfilt(B,A,data);
data1=data-ecg_low; 

[R_val,R_loc] = findpeaks(data1,'minpeakdistance', floor(0.4*fs),'MinPeakHeight',height);
loc = find(R_val<0.3*mean(R_val));
R_loc(loc) = [];

R_val = data1(R_loc);

%% RR interval
RR = diff(R_loc);

%% plot
figure('visible','off')
    plot(data1)
    hold on
    plot(R_loc,data1(R_loc),'o')

    
end

