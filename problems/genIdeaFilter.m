%ws is stop band frequency. If ws=0, it's low pass. And ws=1, it's high
%pass. If ws > wp, it's band stop. If ws < wp, it's band pass.

function [desiredFilter_h,indx_pass,indx_stop] = genIdeaFilter(Problem)

desiredFilter_h = zeros(1,Problem.fs);

for i = 1:1:size(Problem.wp,1)
    wp = round(Problem.wp(i,:)*Problem.fs);
    if wp(1)<1
        wp(1) = 1;
    end
    if wp(2)>Problem.fs
        wp(2) = Problem.fs;
    end
    desiredFilter_h(1,wp(1):wp(2)) = 1;
end

indx_pass = find(desiredFilter_h==1);
indx_stop = find(desiredFilter_h==0);

end