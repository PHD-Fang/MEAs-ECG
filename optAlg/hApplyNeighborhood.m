function solution = hApplyNeighborhood(Xi,Xk,Xbest,Problem,opCode)
    switch(opCode)
        case 1
            solution = soshNeighborhood(Xi,Xk,Xbest,Problem);
        case 2
            solution = gNeighborhood(Xi,Xk,Xbest,Problem);
        case 3
            solution = ggNeighborhood(Xi,Xk,Xbest,Problem);
        otherwise
            fprintf('Unkown neighborhood.\n');
    end
    solution = checkSol(solution,Problem);
end