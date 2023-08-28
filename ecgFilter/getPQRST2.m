function [R_val,R_loc,RR] = getPQRST2(data,fs,r_loc)

%% baseline
len = 100;
fmaxd_1 = 5;%
fmaxn_1 = fmaxd_1/(fs/2);
[B,A] = butter(1,fmaxn_1,'low');
ecg_low=filtfilt(B,A,data);
data1=data-ecg_low;


if r_loc(1) < len
    seg = data1(1:r_loc(1)+len);
    data_loc = floor(median(find(seg == max(seg))));
    R_loc(1) = data_loc;
    R_val(1) = data1(R_loc(1));
else seg = data1(r_loc(1)-len:r_loc(1)+len);
    data_loc = floor(median(find(seg == max(seg))));
    R_loc(1) = r_loc(1)-len+data_loc-1;
    R_val(1) = data1(R_loc(1));
end


for i = 2:length(r_loc)-1
    seg = [];
    seg = data1(r_loc(i)-len:r_loc(i)+len);
    data_loc = floor(median(find(seg == max(seg))));
    R_loc(i) = r_loc(i)-len+data_loc-1;
    R_val(i) = data1(R_loc(i));
end

seg = [];
if length(data1) - r_loc(end) < len
    seg = data1(r_loc(end)-len:end);
    data_loc = floor(median(find(seg == max(seg))));
    R_loc(length(r_loc)) = r_loc(end)-len+data_loc-1;
    R_val(length(r_loc)) = data1(R_loc(length(r_loc)));
else seg = data1(r_loc(end)-len:r_loc(end)+len);
    data_loc = floor(median(find(seg == max(seg))));
    R_loc(length(r_loc)) = r_loc(end)-len+data_loc-1;
    R_val(length(r_loc)) = data1(R_loc(length(r_loc)));
end

%% RR interval
RR = diff(R_loc);

%% plot
figure('visible','off')
    plot(data1)
    hold on
    plot(R_loc,data1(R_loc),'o')
end