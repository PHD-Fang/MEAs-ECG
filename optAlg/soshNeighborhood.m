function solution = soshNeighborhood(Xi,Xk,Xbest,Problem)
    % Mutual vector
    mv=(Xi.Solution+Xk.Solution)/2;
    
    % benefit factor vector
    bf=randi(1,[2,1]);
    nvar = Problem.dim;
    solution=Xi.Solution + rand(1,nvar).*(Xbest.Solution-mv*bf(1));
end