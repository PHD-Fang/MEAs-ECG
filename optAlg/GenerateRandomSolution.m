function solution = GenerateRandomSolution(Problem)

    ub = Problem.up;
    lb = Problem.down;
    D = Problem.dim;
    Range = ub-lb;
    Lower = lb;
    solution = rand(1,D) .* Range + Lower;
    if Problem.isVariableLength && (solution(1)<1)
        error("scout bee error.\r\n");
    end
end