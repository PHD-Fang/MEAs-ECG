function solution = ApplyNeighborhood(Xi,Xk,Problem,opCode)
    switch(opCode)
        case 1
            solution = basicNeighborhood(Xi,Xk,Problem);
        case 2
            solution = oABCNeighborhood(Xi,Xk,Problem);
        case 3
            solution = rABCNeighborhood(Xi,Xk,Problem);
        otherwise
            fprintf('Unkown neighborhood.\n');
    end

    solution(solution>Problem.up) = Problem.up(solution>Problem.up);
    solution(solution<Problem.down) = Problem.down(solution<Problem.down);

end