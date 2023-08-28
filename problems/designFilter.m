function Problem = designFilter(Problem,Parameters)

%Set boundary for solution. Sol(1) is order when variable length problems.
if 1 == Problem.isVariableLength
    Problem.dim=2*Problem.order+2;
    Problem.down=-2*ones(1,Problem.dim);
    Problem.up=2*ones(1,Problem.dim);
    Problem.down(1) = 1; 
    Problem.up(1) = Problem.order;
else
    Problem.dim=2*Problem.order+1;
    Problem.down=-2*ones(1,Problem.dim);
    Problem.up=2*ones(1,Problem.dim);
end

%Get idea filter
[Problem.desiredFilter_h,Problem.indx_pass,Problem.indx_stop] = genIdeaFilter(Problem);

%Get initial solution
Problem.initSol = genInitSol(Problem,Parameters);
filterType = Problem.filterType;
order = Problem.order;
wp = Problem.wp(2);   
[Problem.b,Problem.a] = butter(order,wp,filterType);       
[Problem.cb1,Problem.ca1] = cheby1(order,1,wp,filterType);
[Problem.cb2,Problem.ca2] = ellip(order,1,30,wp,filterType);
[Problem.cb3,Problem.ca3] = cheby1(order,4,wp,filterType);  
[Problem.cb4,Problem.ca4] = cheby1(order,8,wp,filterType);
[Problem.cb5,Problem.ca5] = ellip(order,1,10,wp,filterType);
[Problem.cb6,Problem.ca6] = cheby2(order,1,wp,filterType);
[Problem.cb7,Problem.ca7] = cheby2(order,8,wp,filterType);

%Inset prior solution by classical algorithm
if 1 == Problem.isPreDesign   
    Problem.initSol(2,:) = coef2sol(Problem.b,Problem.a,Problem);
    Problem.initSol(3,:) = coef2sol(Problem.cb1,Problem.ca1,Problem);
    Problem.initSol(4,:) = coef2sol(Problem.cb2,Problem.ca2,Problem);
    Problem.initSol(5,:) = coef2sol(Problem.cb3,Problem.ca3,Problem);
    Problem.initSol(6,:) = coef2sol(Problem.cb4,Problem.ca4,Problem);
    Problem.initSol(7,:) = coef2sol(Problem.cb5,Problem.ca5,Problem);
    Problem.initSol(8,:) = coef2sol(Problem.cb6,Problem.ca6,Problem);
    Problem.initSol(9,:) = coef2sol(Problem.cb7,Problem.ca7,Problem);
end 

end