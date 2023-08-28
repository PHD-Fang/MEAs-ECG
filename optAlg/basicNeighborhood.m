function vi = basicNeighborhood(Xi,Xk,Problem)

    D = size(Xi.Solution,2);
    Param2Change=fix(rand*D)+1;
    vi = Xi.Solution;
    vi(Param2Change)=Xi.Solution(Param2Change)+(Xi.Solution(Param2Change)-Xk.Solution(Param2Change))*(rand-0.5)*2;
    
%     if(vi(Param2Change)<Problem.down)
%         vi(Param2Change)=Problem.down;
%     end
%     if(vi(Param2Change)>Problem.up)
%         vi(Param2Change)=Problem.up;
%     end

end