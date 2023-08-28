%Toward filter
function Problem = towardFilter(Problem,Parameters)

Problem.down=-2;Problem.up=2;Problem.order=5;Problem.dim=2*Problem.order+1;
Problem.knownFilter = 1;
[order,Problem.b,Problem.a] = getIIRCoef(Problem.knownFilter);      
Problem.order=order;Problem.dim=2*Problem.order+1;
[Problem.desiredFilter_h,Problem.indx_pass,Problem.indx_stop] = genSpecFilter(Problem);
Problem.initSol = genInitSol(Problem,Parameters);

end