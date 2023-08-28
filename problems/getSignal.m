function [dSig,sSig,DSIG,SSIG] = getSignal(Problem)

switch Problem.dataType
    case 1 % mit-bih-arrhythmia-database-1.0.0
        [n,ecg] = rdsamp('../ecgData/mit-bih-arrhythmia-database-1.0.0/',Problem.dataName);
        dSig = ecg(Problem.start:Problem.stop,1)';
        noise = genWhiteGauNosie(Problem.len,0.5);
        sSig = dSig + noise;
        N = Problem.len;
        DSIG = fft(Problem.dSig(1:N))/(N/2);
        SSIG = fft(Problem.sSig(1:N))/(N/2);
    otherwise
        fprintf("Unkown data source %s.\r\n",Problem.dataName);
end


end