function [bestScore,bestSol,Convergence] = WSVLPSO(Problem,Parameters, initPos)

Fitness = @(bees) filterFitness(bees,Problem);


nvar    = Problem.dim;%(2 * (O - 1)) + Cst1;
npop    = Parameters.N;
w       = 1;
Cst1 = 2;

maxit   = Parameters.maxIter;
wdamp   = 0.99;
c1      = 2;
c2      = 2;
xmin = Problem.down;
xmax = Problem.up;
dx             = xmax - xmin;
vmax           = 0.1 * dx;
empty_particle.position  = [];
empty_particle.velocity  = [];
empty_particle.cost      = [];
empty_particle.pbest     = [];
empty_particle.pbestcost = [];
empty_particle.nvar      = [];
empty_particle.pnvar     = [];

particle      = repmat(empty_particle,npop,1);
gbest         = zeros(maxit,nvar);
gbestcost     = zeros(maxit,1);
gnvar         = zeros(maxit,1);
meanfit       = zeros(maxit,1);
Temp1particle = zeros(1,nvar); % The initial nvar is the maximom value of the first dimension
Temp1velocity = zeros(1,nvar);
Temp2particle = zeros(1,nvar);
Temp2velocity = zeros(1,nvar);

% Initialize Global Best
it = 1;
gnvar(it)                 = 2 * round(initPos(1,1)) + 2;
gbest(it,1:gnvar(it))     = initPos(1,1:gnvar(it));
gbest(it,gnvar(it)+1:end) = 0;
gbestcost(it)             = Fitness(initPos(1,:));

% Initialize Population Members
for i=1:npop

% Generate Random Solution
particle(i).position = xmin + (xmax - xmin) .* rand(1,nvar); %initPos(i,:);%unifrnd(MinPosition, MaxPosition, 1, Varsize);
particle(1).position = initPos(2,:);
particle(i).position(1) = round(particle(i).position(1));    
particle(i).nvar        = (2 * (particle(i).position(1)))+2;   
% particle(i).velocity = unifrnd(xmin, vmax, 1, particle(i).nvar);
if particle(i).nvar ~= nvar                                     
    dif1 = particle(i).nvar - nvar;                                
    if dif1 < 0                                                  
        particle(i).position = particle(i).position(1:particle(i).nvar);
    else %dif1 > 0                                                  
        particle(i).position(nvar+1:nvar+dif1) = xmin(2:1+dif1)...
        + (xmax(2:1+dif1) - xmin(2:1+dif1)) .* rand(1,dif1);       
    end                                                          
    dif1 = 0;
end    

particle(i).velocity = zeros(1,particle(i).nvar);
% Evaluation
particle(i).cost = Fitness(particle(i).position);
particle(i).pnvar     = particle(i).nvar;
particle(i).pbest = particle(i).position;
particle(i).pbestcost =  particle(i).cost;

if particle(i).pbestcost < gbestcost(it)
        gnvar(it)                 = particle(i).nvar;
        gbest(it,1:gnvar(it))     = particle(i).pbest;
        gbest(it,gnvar(it)+1:end) = 0;
        gbestcost(it)             = particle(i).pbestcost;
end

end


for it = 2:maxit
    gbest(it,:)   = gbest(it - 1,:);
    gbestcost(it) = gbestcost(it - 1);
    gnvar(it)     = gnvar(it - 1);
    
    for i = 1:npop
    
    dif3          = particle(i).pnvar - particle(i).nvar;
    Temp1particle = particle(i).position;
    Temp1velocity = particle(i).velocity;

    
        if dif3 ~= 0
            if dif3 < 0
                Temp1particle = Temp1particle(1:particle(i).pnvar);
                Temp1velocity = Temp1velocity(1:particle(i).pnvar);
            else %dif3 > 0
                Temp1particle(particle(i).nvar+1:particle(i).nvar+dif3)...
                    = xmin(2:1+dif3) + (xmax(2:1+dif3) - xmin(2:1+dif3)) .* rand(1,dif3);
                Temp1velocity(particle(i).nvar+1:particle(i).nvar+dif3)...
                    = min(max(rand(1,dif3),-vmax(2:1+dif3)),vmax(2:1+dif3));
            end
        end

        
    dif4          = gnvar(it) - particle(i).nvar;
    Temp2particle = particle(i).position;
    Temp2velocity = particle(i).velocity;
        
       if dif4 ~= 0
           if dif4 < 0
               Temp2particle = Temp2particle(1:gnvar(it));
               Temp2velocity = Temp2velocity(1:gnvar(it));
           else %dif4 > 0
               Temp2particle(particle(i).nvar+1:particle(i).nvar+dif4)...
                   = xmin(2:1+dif4) + (xmax(2:1+dif4) - xmin(2:1+dif4)) .* rand(1,dif4);
               Temp2velocity(particle(i).nvar+1:particle(i).nvar+dif4)...
                   = min(max(rand(1,dif4),-vmax(2:1+dif4)),vmax(2:1+dif4));

           end
       end
    Temp3pbest = particle(i).pbest - Temp1particle;
    Temp4gbest = gbest(it,1:gnvar(it)) - Temp2particle;
    
    dif5 = particle(i).pnvar - gnvar(it);

        if dif5 ~= 0
            if dif5 < 0
                particle(i).position(particle(i).nvar+1:particle(i).nvar+abs(dif4))...
                    = xmin(2:1+abs(dif4)) + (xmax(2:1+abs(dif4))...
                    - xmin(2:1+abs(dif4))) .* rand(1,abs(dif4));
                particle(i).position = particle(i).position(1:gnvar(it));
                particle(i).nvar     = gnvar(it);
                particle(i).velocity = Temp2velocity;
                Temp3pbest(particle(i).pnvar + 1:gnvar(it)) = ...
                    min(max(rand(1,abs(dif5)),-vmax(2:1+abs(dif5))),vmax(2:1+abs(dif5)));
            else %dif5 > 0
                particle(i).position(particle(i).nvar+1:particle(i).nvar+abs(dif3))...
                    = xmin(2:1+abs(dif3)) + (xmax(2:1+abs(dif3))...
                    - xmin(2:1+abs(dif3))) .* rand(1,abs(dif3));
                particle(i).position = particle(i).position(1:particle(i).pnvar);
                particle(i).nvar     = particle(i).pnvar;
                particle(i).velocity = Temp1velocity;
                Temp4gbest(gnvar(it) + 1:particle(i).pnvar) = ...
                    min(max(rand(1,dif5),-vmax(2:1+dif5)),vmax(2:1+dif5));
            end
        else
            particle(i).position = particle(i).position(1:gnvar(it));
            particle(i).nvar     = gnvar(it);
            particle(i).velocity = Temp2velocity;
        end

        
        particle(i).velocity = w * particle(i).velocity...
            + c1 * rand * Temp3pbest + c2 * rand * Temp4gbest;
        
        particle(i).velocity = min(max(particle(i).velocity,...
            -vmax(1:particle(i).nvar)),vmax(1:particle(i).nvar));
        
        particle(i).position = particle(i).position + particle(i).velocity;
        
        particle(i).position = min(max(particle(i).position,...
            xmin(1:particle(i).nvar)),xmax(1:particle(i).nvar));
        
        particle(i).position(1) = round(particle(i).position(1));
        Temp5nvar               = particle(i).nvar;
        particle(i).nvar        = (2 * (particle(i).position(1)))+Cst1;
        
        if particle(i).nvar ~= Temp5nvar
            dif2 = particle(i).nvar - Temp5nvar;
            if dif2 < 0

                particle(i).position = particle(i).position(1:particle(i).nvar);
                particle(i).velocity = particle(i).velocity(1:particle(i).nvar);
            else %dif2 > 0
                particle(i).position(Temp5nvar+1:Temp5nvar+dif2)...
                    = xmin(2:1+dif2) + (xmax(2:1+dif2) - xmin(2:1+dif2)) .* rand(1,dif2);
                particle(i).velocity(Temp5nvar+1:Temp5nvar+dif2)...
                    = min(max(rand(1,dif2),-vmax(2:1+dif2)),vmax(2:1+dif2));
            end
            Temp5nvar = 0;
            dif2      = 0;
        end
        
      %%%************************ 
      sol = zeros(1,nvar);
      sol(1:particle(i).position(1)+2) = particle(i).position(1:particle(i).position(1)+2);
      sol(round(nvar/2)+2:round(nvar/2)+2+particle(i).position(1)-1) = particle(i).position(particle(i).position(1)+3:end);

      particle(i).cost = Fitness(sol);%Fitness(particle(i).position);
      %%%
        if particle(i).cost < particle(i).pbestcost
            particle(i).pnvar     = particle(i).nvar;
            particle(i).pbest     = particle(i).position;
            particle(i).pbestcost = particle(i).cost;

            if particle(i).pbestcost < gbestcost(it)
                gnvar(it)                 = particle(i).nvar;
                gbest(it,1:gnvar(it))     = particle(i).pbest;
                gbest(it,gnvar(it)+1:end) = 0;
                gbestcost(it)             = particle(i).pbestcost;
            end
        end
    end
    w = w * wdamp;
    
end
Convergence = gbestcost;
bestScore = gbestcost(it);
bestSol = gbest(it,1:gnvar(it));
end

