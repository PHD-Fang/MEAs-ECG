%ws is stop band frequency. If ws=0, it's low pass. And ws=1, it's high
%pass. If ws > wp, it's band stop. If ws < wp, it's band pass.

function [desiredFilter_h,indx_pass,indx_stop] = genSpecFilter(Problem)

b=Problem.b;
a=Problem.a;
[h,w] = freqz(b,a,Problem.fs);
desiredFilter_h = abs(h)';

indx_pass = find(desiredFilter_h>0.5);
indx_stop = find(desiredFilter_h<0.5);

end