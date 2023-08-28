
function [bestScore,bestSol,Convergence] = PSO(Problem,Parameters, initPos)

%% Parameters of PSO

MaxIt = Parameters.maxIter;           % Maximum Number of Iterations

nPop = Parameters.N;              % Population Size (Swarm Size)  Size of the frequency list
w = 0.3;                % Intertia Coefficient
wdamp = 0.999;          % Damping Ratio of Inertia Coefficient
c1 = 2;                 % Personal Acceleration Coefficient
c2 = 2;                 % Social Acceleration Coefficient
ShowIterInfo = true;    % Flag for Showing Iteration Informatin
isfirstPrint = false;
Varsize = Problem.dim;

MaxPosition = 2;
MinPosition = -2;
MaxVelocity = 2;
MinVelocity = -2;

obj = @(bees) filterFitness(bees,Problem);
%% Initialization

% The Particle Template
particle.Position = [];
particle.Velocity = [];
particle.Best.Position = [];
particle.Cost = [];
particle.Best.Cost = [];
GlobalBest.Cost=inf;


% Create Population Array
%particle = repmat(particle, nPop, 1);

% Initialize Global Best
GlobalBest.Position = initPos(1,:);%unifrnd(MinPosition, MaxPosition,1,Varsize);
GlobalBest.Cost = obj(GlobalBest.Position);

% Initialize Population Members
for i=1:nPop

    % Generate Random Solution
    particle(i).Position = initPos(i,:);%unifrnd(MinPosition, MaxPosition, 1, Varsize);
    particle(i).Velocity = unifrnd(MinVelocity, MaxVelocity, 1,Varsize);
    
    % Evaluation
    particle(i).Cost = obj(particle(i).Position);
   
    particle(i).Best.Position = particle(i).Position;
    particle(i).Best.Cost =  particle(i).Cost;
   
    if particle(i).Best.Cost < GlobalBest.Cost
        GlobalBest.Position  = particle(i).Position;
        GlobalBest.Cost = particle(i).Best.Cost;
    end

end
BestCost=zeros(MaxIt,1);

%% Main Loop of PSO
for it=1:MaxIt

    for i=1:nPop
       
        % Update Velocity
        for j = 1:Varsize
            particle(i).Velocity(j) = w*particle(i).Velocity(j) ...
                + c1*rand*(particle(i).Best.Position(j) - particle(i).Position(j)) ...
                + c2*rand*(GlobalBest.Position(j) - particle(i).Position(j));
        end
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        particle(i).Position = checkSol(particle(i).Position,Problem);

        newCost = obj(particle(i).Position);
        % Update Local Best
        if newCost < particle(i).Best.Cost
            particle(i).Best.Position = particle(i).Position;
            particle(i).Best.Cost = newCost;
            
        %  update global cost
          if GlobalBest.Cost > particle(i).Best.Cost
              GlobalBest.Cost = particle(i).Best.Cost;
              GlobalBest.Position = particle(i).Best.Position;
          end
        end
    end
    BestCost(it)=GlobalBest.Cost;
     
    % Damping Inertia Coefficient
    w = w * wdamp;
end

% save('particle.mat','particle');
Convergence = BestCost';
bestScore = GlobalBest.Cost;
bestSol = GlobalBest.Position;
end