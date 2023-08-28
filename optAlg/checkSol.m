function solution = checkSol(solution,Problem)
    solution(solution>Problem.up) = Problem.up(solution>Problem.up);
    solution(solution<Problem.down) = Problem.down(solution<Problem.down);
    if(isnan(solution(1)))
        error("err sol(1).\r\n")
        Xi
        Xk
        Xbest
    end
end
