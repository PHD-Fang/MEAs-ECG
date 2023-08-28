

function [bestScore,bestSol,Convergence] = SOS(Problem,Parameters, initPos)

CostFunction = @(bees) filterFitness(bees,Problem);
npob  =Parameters.N;        % population size
nvar  =Problem.dim;         % number of optimized variables

ub = Problem.up;
lb = Problem.down;

for i=1:npob
    xt(i).Solution = initPos(i,:);%GenerateRandomSolution(Parameters.D);
    xt(i).Cost = CostFunction(xt(i).Solution);
end
[bestScore,indx] = min([xt.Cost]);
bestSol = xt(indx).Solution;
Convergence(1) = bestScore;

for iter=2:Parameters.maxIter
    for it=1:npob
        %------------------------------ Mutualism -------------------------------
        % choosing the random organism
        jt=randi(npob-1);
        jt=jt+(jt>=it);
        
        % Mutual vector
        mv=(xt(it).Solution+xt(jt).Solution)/2;
        
        % benefit factor vector
        bf=randi(2,[2,1]);
        
        % new organisms
        xin=xt(it).Solution + rand(1,nvar).*(bestSol-mv*bf(1));
        xjn=xt(jt).Solution + rand(1,nvar).*(bestSol-mv*bf(2));

        xin(xin>ub)=ub(xin>ub); xin(xin<lb)=lb(xin<lb);
        xjn(xjn>ub)=ub(xjn>ub); xjn(xjn<lb)=lb(xjn<lb);
        
        % objective function value of new organisms
        xin = [xt(it).Solution(1),xin(2:end)];
        xjn = [xt(jt).Solution(1),xjn(2:end)];
        fitin=CostFunction(xin);
        fitjn=CostFunction(xjn);
        
        % Replace old organism if the new organisms have a better (lower) fitness
        if fitin < xt(it).Cost
            xt(it).Solution=xin;
            xt(it).Cost = fitin;
        end
        if fitjn < xt(jt).Cost
            xt(jt).Solution = xjn;
            xt(jt).Cost = fitjn;
        end
        
        %------------------------- Comensalismo --------------------------------
        % choosing the random organism
        jt=randi(npob-1);
        jt=jt+(jt>=it);
        
        % new organism
        xin=xt(it).Solution + (2*rand(1,nvar)-1).*(bestSol - xt(jt).Solution);
        xin(xin>ub)=ub(xin>ub); xin(xin<lb)=lb(xin<lb);
        
        % objective function value of new organisms
        xin = [xt(it).Solution(1),xin(2:end)];
        fitin=CostFunction(xin);
        
        % Replace old organism if the new organisms have a better (lower) fitness
        if fitin < xt(it).Cost
            xt(it).Solution=xin;
            xt(it).Cost = fitin;
        end

        
        %----------------------- Parasitism -----------------------------------
        % choosing the random organism
        jt=randi(npob-1);
        jt=jt+(jt>=it);
        
        % number of dimensions that are going to be modified
        nd=randi(nvar);
        % dimensions that are going to be modified
        cd=randperm(nvar);
        cd=cd(1:nd);
        
        % parasite vector
        xp=xt(it).Solution;
        xp(cd)=rand(1,nd).*(ub(1:nd)-lb(1:nd))+lb(1:nd);
        xp(xp>ub)=ub(xp>ub); xp(xp<lb)=lb(xp<lb);

        % fitness of parasite organism
        xin = [xt(it).Solution(1),xp(2:end)];
        fitp = CostFunction(xp);
        
        % Replace host organism if parasite organism has a better fitness
        if fitp < xt(jt).Cost
            xt(jt).Solution = xp;
        end
    end

    [bestScore,indx] = min([xt.Cost]);
    bestSol = xt(indx).Solution;
    Convergence(iter) = bestScore;

end%iter = 1:1:ittot
%     save('xt.mat','xt');
end
