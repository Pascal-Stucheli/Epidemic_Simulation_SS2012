% Final Simulation

function FINAL_SIMULATION_whole_run

parfor b=1:1
    
    %load network
    
    cities = dlmread('cities.txt');
    
    %Set random infection for this experiment
    root= unidrnd(length(cities(:,1)));
    cities(root,3)=1;
    
    edges = dlmread('edges.txt');
    tot_T = ceil(dlmread('tot_T.txt')/100);
    
    %parameter definition
    dt = 2; %hours
    runtime = 24*80; %hours
    t = 0; %initialization
    meeting_events_mean = 7.5;%per day
    meeting_events_stdev = 7;%per day
    infection_prob = 0.05; %infection probability on meeting event
    g = 1;
    output_array = zeros(length(cities(:,1)),runtime/dt);
    tot_pop=sum(cities(:,2));
    
    %main step runs through the whole time
    
    while t < runtime
        
        %1. Step Traffic
        
        cities = transport_with_fixed_tot_T(cities,edges,tot_T);
        
        %2. Step Infection
        
        cities = Simulate_Infection(cities,dt,meeting_events_mean,meeting_events_stdev,infection_prob,t);
        
        % Time update
        output_array(:,g) = cities(:,3);
        t = t + dt;
        g = g + 1;
        
    end
    
     out_file_name = 'exp61new.txt';
     out_file_name(5) = int2str(b);
     dlmwrite(out_file_name,output_array);
    %generate_output(output_array, tot_pop,cities,root,edges,b);
    
end
end

function cities = Simulate_Infection(cities,dt,meeting_events_mean,meeting_events_stdev,infection_prob,t)

meetings_stdev = meeting_events_stdev/24*dt; %66 percent of meetings par day are in mean +- stdev range
meetings_mean = meeting_events_mean/24*dt; %meetings per day calculated to dt proportional
number_of_cities = length(cities(:,1));

for n = 1:number_of_cities
    
    infected = cities(n,3);
    susceptible = (cities(n,2)-infected);
    
    if infected > 0 && susceptible > 0 %don't go on if there are no infected or no susceptibles left
        
        if infected < 10000 %if this holds calculate stochastic
            meeting_events = round(abs(randn*meetings_stdev*infected + meetings_mean*infected)); %calculate the meeting events
            dI = binornd(meeting_events, infection_prob*susceptible/(susceptible+infected)); %approximate how many of these meetings result in an infection
            %probability = infection_prob*part of susceptible in population
            %not approximated method attached in the end
            cities(n,3) = infected + dI; %update population
            
            if cities(n,3) > cities(n,2) %not more infected possible than whole population
                cities(n,3) = cities(n,2);
            end
            
        else %if infected > 10000 deterministic approximation
            meeting_events = round(abs(randn*meetings_stdev*infected + meetings_mean*infected)); %calculate the meeting events
            dI = ceil(meeting_events*infection_prob*susceptible/(susceptible+infected)); %approximate how many of these meetings result in an infection
            %probability = infection_prob*part of susceptible in population
            %not approximated method attached in the end
            cities(n,3) = infected + dI; %update population
            
            if cities(n,3) > cities(n,2) %not more infected possible than whole population
                cities(n,3) = cities(n,2);
            end
        end
        
    end
end

end

function cities = transport_with_fixed_tot_T(cities,edges,tot_T)
% This function is meant to be the interface between the network and the disease simulation.

N = cities(:,2); % Total population
I = cities(:,3); % Infected
S = N-I; % Susceptibles

% Transport matrix
% col1: Infected voyagers going x -> y; col2: Infected voyagers going y -> x
T = zeros(length(edges(:,2)),2);

%unsort edges
for i = 1:length(edges)
    r(1) = ceil(rand*length(edges));
    r(2) = ceil(rand*length(edges));
    temp_edges = edges(r(1),:);
    temp_tot_T = tot_T(r(1));
    tot_T(r(1)) = tot_T(r(2));
    tot_T(r(2)) = temp_tot_T;
    edges(r(1),:) = edges(r(2),:);
    edges(r(2),:) = temp_edges;
end


for i = 1:length(edges)
    
    x = edges(i,1); % It is not necessary to define x and y but it may helps with the overview
    y = edges(i,2);
    
    % in order to reduce unused computational efforts -> only calculate transport if at
    % least one city at the end of the edge has infected people. Also, no
    % transport between fully infected cities.
    
    % We assume that the number of infected voyagers is binomial distributed with n = T(i,1) and p = I(x or y)/N(x or y)
    %
    if I(x) < N(x) && I(x) > 0
        [mean, var] = hygestat(N(x),I(x),tot_T(i));
        T(i,1) = abs(round(randn*sqrt(var) + mean));
        %T(i,1) = binornd(tot_T(i),I(x)/N(x)); % Infected voyagers traveling from x to y.
        
    elseif I(x) == N(x)
        T(i,1) = tot_T(i);
        
    else T(i,1) = 0;
        
    end
    
    if I(y) < N(y) && I(y) > 0
        
        [mean, var] = hygestat(N(y),I(y),tot_T(i));
        T(i,2) = abs(round(randn*sqrt(var) + mean));
        %T(i,2) = binornd(tot_T(i),I(y)/N(y)); % " " " " y to x.
        
    elseif I(y) == N(y)
        T(i,2) = tot_T(i);
        
    else T(i,2) = 0;
        
    end
    
    
    % Calculate changes of S and I of city x and y and update.
    
    % Derivation: Sx: Total S of city x, Ix: Total I of city x, TS_x-y:
    % S leaving city x, TI_x-y: I leaving city x. Same for city y, Txy:
    % Total voyagers (= TS_xy + TI_xy)
    % Sx = Sx,old - TS_x-y + TI_y-x = Sx,old - (Txy - TI_x-y) + (Txy -
    % TI_y-x) = Sx,old + TI_x-y - TI_y-x
    
    %S_T(x) = S_T(x) + T(i,1) - T(i,2);
    I(x) = I(x) + T(i,2) - T(i,1); % Update number of infected in city x
    %S_T(y) = S_T(y) + T(i,2) - T(i,1);
    I(y) = I(y) + T(i,1) - T(i,2); % Update number of infected in city y
    
    % With the binomial assumption a infected person can be drawn more than
    % one time per round, therefore negative I(x or y) must avoided:
    if I(x) < 0
        I(y)= I(y) + I(x);
        I(x) = 0;
        
    end
    
    if I(y) < 0
        I(x)=I(x)+I(y);
        I(y) = 0;
    end
    
    if I(x) > N(x)
        I(y)=I(y)-I(x)+N(x);
        I(x)=N(x);
    end
    
    if I(y) > N(y)
        I(x)=I(x)-I(y)+N(y);
        I(y)=N(y);
    end
    
end

cities(:,3) = I; % Update cities matrix.

end

function generate_output(output_array, tot_pop, cities, root,edges,b)

bstr = int2str(b);

%calculate and produce file for number of cities with at least 20% infected
percent_10_infected(length(output_array(1,:)))=0;
ratio(length(output_array(1,:)))=0;

for i = 1:length(output_array(1,:))
    percent_10_infected(i)=0;
    ratio(i) = sum(output_array(:,i))/tot_pop;
    for g = 1:length(output_array(:,1))
        if output_array(g,i)/cities(g,2) >= 0.1
            percent_10_infected(i) = percent_10_infected(i) + 1; 
        end
    end
end

percent_corr_name='percent_10_total_000.txt';
percent_corr_name(21-length(bstr):20)=bstr;
dlmwrite(percent_corr_name,percent_10_infected);
ratio_2nd_name='ratio_2nd_000.txt';
ratio_2nd_name(14-length(bstr):13)=bstr;
dlmwrite(ratio_2nd_name,ratio);
end