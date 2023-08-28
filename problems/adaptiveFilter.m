function Problem = adaptiveFilter(Problem,Parameters)
Problem.dataType = 1;%MIT.
Problem.dataName = '118';
Problem.time = 2;
Problem.start = Problem.fs*60*5;
Problem.len = Problem.fs * Problem.time;
Problem.stop = Problem.start + Problem.len - 1;
[Problem.dSig,Problem.sSig,Problem.DSIG,Problem.SSIG] = getSignal(Problem);

showProblem(Problem);

Problem.down=-2;Problem.up=2;Problem.order=5;Problem.dim=2*Problem.order+1;
Problem.wp = [1/(Problem.fs/2),1];%[0,0.48];
[Problem.desiredFilter_h,Problem.indx_pass,Problem.indx_stop] = genIdeaFilter(Problem);
[Problem.b,Problem.a] = butter(Problem.order,Problem.wp(1),"high");
Problem.isPreDesign = 1;
[Problem.cb1,Problem.ca1] = cheby1(Problem.order,2,Problem.wp(1),'high');
[Problem.cb2,Problem.ca2] = cheby1(Problem.order,5,Problem.wp(1),'high');
[Problem.cb3,Problem.ca3] = cheby1(Problem.order,10,Problem.wp(1),'high');
Problem.initSol = genInitSol(Problem,Parameters);
Problem.initSol(2,:) = [Problem.b,Problem.a(2:end)];
Problem.initSol(2,:) = [Problem.cb1,Problem.ca1(2:end)];
Problem.initSol(2,:) = [Problem.cb2,Problem.ca2(2:end)];
Problem.initSol(3,:) = [Problem.cb2,Problem.ca3(2:end)];
end