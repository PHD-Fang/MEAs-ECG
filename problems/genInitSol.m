function initSol = genInitSol(Problem,Parameters)
   
    ub = Problem.up;
    lb = Problem.down;
    FoodNumber = Parameters.N;
    D = Problem.dim;
    if Problem.isVariableLength == 0
        Range = repmat((ub-lb),[FoodNumber 1]);
        Lower = repmat(lb, [FoodNumber 1]);
        Foods = rand(FoodNumber,D) .* Range + Lower;
    else
        Foods = zeros(FoodNumber,D);
%         Foods(:,1) = randi(Problem.order,FoodNumber,1);
        Foods(:,1) = ones(FoodNumber,1);
        for i = 1:1:FoodNumber
            order = round(Foods(i,1));
            Foods(i,2:(order+2)) = rand(1,(order+1)).*(ub(1,2:(order+2))-lb(1,2:(order+2)))+lb(1,2:(order+2));
            p = round(Problem.dim/2)+2;
            Foods(i,p:(p+order-1))=rand(1,order).*(ub(1,p:(p+order-1))-lb(1,p:(p+order-1)))+lb(1,p:(p+order-1));
        end
    end

    
    fit = inf * ones(1,Parameters.N);
    for i = 1:1:Parameters.N
        fit(i) = filterFitness(Foods(i,:),Problem);
    end
    [val,indx] = min(fit);
    temp = Foods(indx,:);
    Foods(indx,:) = Foods(1,:);
    Foods(1,:) = temp;
    initSol = Foods;
end