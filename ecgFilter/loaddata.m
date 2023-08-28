function [ecg] = loaddata(a,b,c,opath)

% PATH= 'D:\论文\oBABC-Filter\ecgData\mit-bih-arrhythmia-database-1.0.0\'; % path, where data are saved
PATH = opath;
% HEADERFILE= '101.hea';      % header-file in text format
% ATRFILE= '101.atr';         % attributes-file in binary format
% DATAFILE='101.dat';         % data-file

HEADERFILE= c;      % header-file in text format
ATRFILE= a;         % attributes-file in binary format
DATAFILE=b;         % data-file

SAMPLES2READ=660000;         % number of samples to be read
                            % in case of more than one signal:
                            % 2*SAMPLES2READ samples are read
%------ LOAD BINARY DATA --------------------------------------------------
signald= fullfile(PATH, DATAFILE);            % data in format 212
fid2=fopen(signald,'r');
A= fread(fid2, [3, SAMPLES2READ], 'uint8')'; 
% figure;plot(A(:,1))
% figure;plot(A(:,2))
% figure;plot(A(:,end))
fclose(fid2);

M2H= bitshift(A(:,2), -4);          
M1H= bitand(A(:,2), 15);            
M( : , 1)= bitshift(M1H,8)+ A(:,1); 
M( : , 2)= bitshift(M2H,8)+ A(:,3); 
M = M-1024;                               
m=0.005*(M);
t = (1:1600)/360;
ecg=m(1:end,1);
end