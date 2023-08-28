function solution = ggNeighborhood(Xi,Xk,Xbest,Problem)
    D = size(Xi.Solution,2);
    Param2Change=fix(rand*D)+1;
    vi = Xi.Solution;
    vi(Param2Change)=Xi.Solution(Param2Change)...
                        +(Xi.Solution(Param2Change)-Xk.Solution(Param2Change))*rand * 0.5 * sign(Xk.Cost - Xi.Cost)...
                        +(Xbest.Solution(Param2Change)-Xi.Solution(Param2Change))*rand * 0.5;
    solution = vi;
end