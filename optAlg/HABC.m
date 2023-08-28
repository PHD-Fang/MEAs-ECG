 %%% ABC %%%

%current_position:  Position of sperms
%velocity:          Velocity
%dim:               Dimension of test functions
%n:                 Number of sperms
%low:               The lower bound of the search space
%up:                The higher bound of the search space
function [bestScore,bestSol,Convergence] = HABC(Problem,Parameters, initPos, opCode)
    
% CostFunction= @(bees) benchmark_functions(bees,Problem.Benchmark_Function_ID,Problem.dim);     % Cost Function
CostFunction = @(bees) filterFitness(bees,Problem);
Convergence = inf*ones(1,Parameters.maxIter);

NB = Parameters.N/2;
limit = (NB*Problem.dim)*1.5;
%     notUpdateTimes = 0;

for i=1:NB
    Bees(i).Solution = initPos(i,:);%GenerateRandomSolution(Parameters.D);
    Bees(i).Cost = CostFunction(Bees(i).Solution);
    Bees(i).Fitness = CalculateFitness(Bees(i).Cost);
    Bees(i).Trial = 0;
end

[bestScore,indx] = min([Bees.Cost]);
bestSol = Bees(indx).Solution;
Convergence(1) = bestScore;
% minIter = round(Parameters.MaxFuncEval/Parameters.N) + 1;
% firstFlag = 0;

iter = 1;
while iter < Parameters.maxIter
    iter = iter + 1;
    for i=1:NB
        neighbor = tournement_selection(NB);
        while neighbor==i
            neighbor = tournement_selection(NB);
        end
        NewSolution.Solution = ApplyNeighborhood(Bees(i),Bees(neighbor),Problem,opCode);
%         notUpdateTimes = notUpdateTimes + compare(Bees(i).Solution,Bees(neighbor).Solution,NewSolution.Solution);
        NewCost = CostFunction(NewSolution.Solution);
        if NewCost >= Bees(i).Cost
            Bees(i).Trial=Bees(i).Trial+1;
        else
            Bees(i).Solution = NewSolution.Solution;
            Bees(i).Cost = NewCost;
            Bees(i).Fitness = CalculateFitness(Bees(i).Cost);
            Bees(i).Trial=0;
        end
    end
    probs=(0.9.*[Bees.Fitness]./max([Bees.Fitness]))+0.1;
    i=1;
    t=0;
    while t<NB
%         i
        if rand<probs(i)
            t=t+1;
            neighbor = tournement_selection(NB);
            while neighbor==i
                neighbor = tournement_selection(NB);
            end
            NewSolution.Solution = hApplyNeighborhood(Bees(i),Bees(neighbor),Bees(indx),Problem,opCode);
%             notUpdateTimes = notUpdateTimes + compare(Bees(i).Solution,Bees(neighbor).Solution,NewSolution.Solution);
            NewCost = CostFunction(NewSolution.Solution);
            if NewCost >= Bees(i).Cost
                Bees(i).Trial=Bees(i).Trial+1;
            else
                Bees(i).Solution = NewSolution.Solution;
                Bees(i).Cost = NewCost;
                Bees(i).Fitness = CalculateFitness(Bees(i).Cost);
                Bees(i).Trial=0;
            end
        end
        i=mod(i,NB)+1;
    end
    for i=1:NB
        if Bees(i).Trial>limit
            Bees(i).Solution = GenerateRandomSolution(Problem);
            Bees(i).Cost = CostFunction(Bees(i).Solution);
            Bees(i).Fitness = CalculateFitness(Bees(i).Cost);
            Bees(i).Trial = 0;
            break;
        end
    end

%     ind=find([Bees.Trial]==max([Bees.Trial]));
%     ind=ind(end);
%     if Bees(ind).Trial>limit
%         Bees(ind).Solution = GenerateRandomSolution(Problem);
%         Bees(ind).Cost = CostFunction(Bees(i).Solution);
%         Bees(ind).Fitness = CalculateFitness(Bees(i).Cost);
%         Bees(ind).Trial = 0;
%     end

    [iterBestCost,indx] = min([Bees.Cost]);
   	if bestScore > iterBestCost
        bestScore = iterBestCost;
        bestSol = Bees(indx).Solution;
    end



    Convergence(iter) = bestScore;
end

% save('bees.mat','Bees')

end