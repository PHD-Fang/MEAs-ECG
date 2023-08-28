function vi = rABCNeighborhood(Xi,Xk,Problem)

    vi = Xi.Solution;
    bitOne = abs(Xi.Solution - Xk.Solution);
    [val,indx]=max(bitOne);
    probs = 1.2*bitOne/val;
    Param2Change = indx;
    vi(Param2Change)=Xi.Solution(Param2Change)+(Xi.Solution(Param2Change)-Xk.Solution(Param2Change))*(rand-0.5)*2;

    count = 0;
    for Param2Change = 1:1:size(vi,2)
        if rand<probs(Param2Change)
            count = count + 1;
            vi(Param2Change)=Xi.Solution(Param2Change)+(Xi.Solution(Param2Change)-Xk.Solution(Param2Change))*(rand-0.5)*2;
        end
    end
%     fprintf("Count: %d, Rate: %.2f.\r\n",count,count/Problem.dim);
end