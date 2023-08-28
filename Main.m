% ABC source code
clear all
clc
close all
addpath('optAlg')
addpath('problems')
addpath('objFuns')
addpath('utils')

Alg = {'ABC','PSO','SOS','SSA','WOA'};
problem_start = 2;
problem_stop = 2;

for Function_No=problem_start:problem_stop

Filter_Function_ID = Function_No; 


Parameters.N = 100;
Parameters.maxIter = 1200;
Parameters.MaxFuncEval = Parameters.N * Parameters.maxIter;
Problem = filter_function_define(Filter_Function_ID,Parameters)

algLen = 5;
Nr = 2;

headInfo.ProblemID = Function_No;
headInfo.algNum = algLen;
headInfo.Nr = Nr;
headInfo.dim = Problem.dim;
headInfo.isVariableLength = Problem.isVariableLength;
headInfo.order = Problem.order;
headInfo.Alg = {'ABC','PSO','SOS','SSA','WOA'};

for r=1:1:Nr
    initPos = Problem.initSol;
    o = 1;    
    opCode = 1;
    tic
    Function{Function_No}.AlgName{o} = Alg{o};
    [Function{Function_No}.bestScore(o,r),...
        Function{Function_No}.bestSol(o).data(r,:),...
        Function{Function_No}.Convergence{o}.data(r,:)] = ZABC(Problem,Parameters, initPos, opCode);
    fprintf("Alg %d %s is finished at epoch %d.\r\n",o,Alg{o},r);
    toc

    o = 2;
    tic
    Function{Function_No}.AlgName{o} = Alg{o};
    [Function{Function_No}.bestScore(o,r),...
        Function{Function_No}.bestSol(o).data(r,:),...
        Function{Function_No}.Convergence{o}.data(r,:)] = PSO(Problem,Parameters, initPos);
    fprintf("Alg %d %s is finished at epoch %d.\r\n",o,Alg{o},r);
    toc

    o = 3;
    tic
    Function{Function_No}.AlgName{o} = Alg{o};
    [Function{Function_No}.bestScore(o,r),...
        Function{Function_No}.bestSol(o).data(r,:),...
        Function{Function_No}.Convergence{o}.data(r,:)] = SOS(Problem,Parameters, initPos);
    fprintf("Alg %d %s is finished at epoch %d.\r\n",o,Alg{o},r);
    toc

    o = 4;
    tic
    Function{Function_No}.AlgName{o} = Alg{o};
    [Function{Function_No}.bestScore(o,r),...
        Function{Function_No}.bestSol(o).data(r,:),...
        Function{Function_No}.Convergence{o}.data(r,:)] = SSA(Problem,Parameters, initPos);
    fprintf("Alg %d %s is finished at epoch %d.\r\n",o,Alg{o},r);
    toc

    o = 5;
    tic
    Function{Function_No}.AlgName{o} = Alg{o};
    [Function{Function_No}.bestScore(o,r),...
        Function{Function_No}.bestSol(o).data(r,:),...
        Function{Function_No}.Convergence{o}.data(r,:)] = WOA(Problem,Parameters, initPos);
    fprintf("Alg %d %s is finished at epoch %d.\r\n",o,Alg{o},r);
    toc
end

for o = 1:1:algLen
    [val,indx] = min(Function{Function_No}.bestScore(o,:));
    showHfilt(Function{Function_No}.bestSol(o).data(indx,:),Problem,Alg{o});
    [fit,err] = filterFitness(Function{Function_No}.bestSol(o).data(indx,:),Problem);
    fit,err
end
 
figure()
for o=1:1:algLen
    plot(mean(Function{Function_No}.Convergence{o}.data,1),'LineWidth',1);hold on
end
legend('ABC','PSO','SOS','SSA','WOA');
xlabel('Iteration');ylabel('Fitness(Best-so-far)');
set(gca,'FontSize',24,'Fontname','Times New Roman');

Function{Function_No}.Problem = Problem;
Function{Function_No}.headInfo = headInfo;
end

save('Result/Function4order048low.mat','Function');
save('Result/headInfo4order048low.mat','headInfo');
save('Result/Problem4order048low.mat','Problem');
