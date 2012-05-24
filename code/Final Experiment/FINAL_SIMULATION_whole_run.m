
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Epidemics Simulation
% 24.5.2012, Lecture with Computer Exercises: Modelling and Simulating
% Social Systems with MATLAB
% By Christian Jordi, Yannick Schmid, Pascal Stüchel
%
%
% This program simulates an epidemic disease outbreak in a imaginary
% environment. With a second program a city network was created with traffic
% between them. The simulation in this program calculates the traffic and
% infections with a fast approximated stochastic algorithm.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Different versions were used % --- indicate another version. If any of
%these functions are used it is not ensured that they work in the present
%version because many small changes allways had to be done

function FINAL_SIMULATION_whole_run
%%
%Each run with b is a whole new simulation for the entire simulation
%duration. Parfor uses all processors the computer provides. To get this
%calculation power bonus the cores must be connected with "matlabpool open"
%Doing this will give a linear speed bonus with the number of processors.
parfor b=1:500
    
    %Load city information
    cities = dlmread('cities.txt');
    
    %Set random infection root for this experiment
    root= unidrnd(length(cities(:,1)));
    cities(root,3)=1;
    
    %Load connections between the cities
    edges = dlmread('edges.txt');
    
    %Load the number of transports per tick per connection between two
    %cities
    tot_T = ceil(dlmread('tot_T.txt')/100);
    
    %An other version for the distance correlation used a slightely
    %different code in addition. Its just here for a complete code.
    % ---
    
    %     target_city = root;
    %     while target_city == root
    %         target_city = unidrnd(length(cities(:,1)));
    %     end
    %
    %     testsparse = sparse(10000,10000);
    %     for i = 1:length(edges)
    %         testsparse(edges(i,1),edges(i,2))=1;
    %         testsparse(edges(i,2),edges(i,1))=1;
    %     end
    %
    %     distance = graphshortestpath(testsparse,root,target_city);
    %     testsparse = 0;
    
    % ---
    
    %Parameter definition
    dt = 2; %Tick duration hours
    runtime = 24*80; %Whole runtime hours
    t = 0; %Initialization
    meeting_events_mean = 7.5;%Number of meeting events per day mean
    meeting_events_stdev = 7;%Number of meeting events per day stdev
    infection_prob = 0.05; %Infection probability on meeting event
    g = 1; %Initialization
    output_array = zeros(length(cities(:,1)),runtime/dt); %Initialization
    tot_pop=sum(cities(:,2)); %Calculate total population
    
    %Go through all timesteps
    while t < runtime
        %% Main step for each time tick
        
        %1. Step Traffic
        cities = transport_with_fixed_tot_T(cities,edges,tot_T);
        
        %2. Step Infection
        cities = Simulate_Infection(cities,dt,meeting_events_mean,meeting_events_stdev,infection_prob,t);
        
        %3. Update time and variables
        output_array(:,g) = cities(:,3);
        
        %For the distance correlation a break condition was used because
        %not the whole simulation had to be run. The break condition comes
        %into play when the target city is infected.
        % ---
        %         if cities(target_city,3) > 0
        %             generate_output(output_array, tot_pop, cities, root,edges,b,t,distance)
        %             break
        %         end
        % ---
        
        %For the degree correlation another break condition was used
        %because not the whole simulation had to be run. The break
        %condition comes into play when at least 20 cities are infected.
        % ---
        %         if length(find(cities(:,3)>=1))>=20
        %             generate_output(output_array, tot_pop, cities, root,edges,b,t)
        %             break
        %         end
        % ---
        
        t = t + dt;
        g = g + 1;
        
    end
    
    %Generate what needs to be saved (Whole experiment would be over 50 mb
    %for each run, which is not possible to save several 100 times.)
    generate_output(output_array, tot_pop,cities,root,edges,b);
    
end


%To enable it to shut down the computer after whole simulation use:
% dos('shutdown /s')
% quit
end

function cities = Simulate_Infection(cities,dt,meeting_events_mean,meeting_events_stdev,infection_prob,t)
%% Function which calculates the infection spreading in one city per tick

%Calculate parameters for one tick and initialize
meetings_stdev = meeting_events_stdev/24*dt; %66 percent of meetings par day are in mean +- stdev range
meetings_mean = meeting_events_mean/24*dt;
number_of_cities = length(cities(:,1));

%Run through each city
for n = 1:number_of_cities
    
    %% Calculate infections for each city
    
    %Set temporary parameters
    infected = cities(n,3);
    susceptible = (cities(n,2)-infected);
    
    %Don't go on if there are no infected or no susceptibles left in the
    %city (performance)
    if infected > 0 && susceptible > 0
        %%
        %If infected are below 10000 in the city calculate with a random
        %part in the calculateion
        if infected < 10000
            %%
            %Calculate meeting events between infected and any other people
            %Normally distributed, rounded and abs taken
            meeting_events = round(abs(randn*meetings_stdev*infected + meetings_mean*infected));
            
            %Calculate meeting events which result in an infection
            %(approximation because detailed calculation would not be
            %possible for up to 93 million people!)
            dI = binornd(meeting_events, infection_prob*susceptible/(susceptible+infected));
            
            %Update population
            cities(n,3) = infected + dI;
            
            %Not more infected possible than whole population (due to
            %approximation this would be possible)
            if cities(n,3) > cities(n,2)
                cities(n,3) = cities(n,2);
            end
            
            %If infected are above 10000 in the city calculate without a random
            %part
            
        else
            %%
            %Calculate meeting events between infected and any other people
            %Normally distributed, rounded and abs taken
            meeting_events = round(abs(randn*meetings_stdev*infected + meetings_mean*infected));
            
            %Just take the mean of infections which would happen in this
            %case and round up. Approximation again, for higher population
            %maybe even more accurate.
            dI = ceil(meeting_events*infection_prob*susceptible/(susceptible+infected));
            
            %Update population
            cities(n,3) = infected + dI;
            
            %Not more infected possible than whole population (due to
            %approximation this would be possible)
            if cities(n,3) > cities(n,2)
                cities(n,3) = cities(n,2);
            end
        end
    end
end
end

function cities = transport_with_fixed_tot_T(cities,edges,tot_T)
%% Function which calculates the transport of infected people

N = cities(:,2); % Total population
I = cities(:,3); % Infected

% Transport matrix
% Col1: Infected voyagers going x -> y; Col2: Infected voyagers going y -> x
T = zeros(length(edges(:,2)),2);

%Unsort edges matrix (is needed because otherwise allways the large cities
%would calculate the travel first which could lead to artifacts.
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

%Run through all connections
for i = 1:length(edges)
    %%
    
    %For better overview define x as city 1 in the edges matrix and y as
    %city 2 in the edges matrix
    x = edges(i,1);
    y = edges(i,2);
    
    %Only calculate the transport if there are any infected in the two
    %connected cities and if there are any susceptible
    if I(x) < N(x) && I(x) > 0
        
        %Hygestat calculates mean and variance for the hypergeometric
        %distribution. As a very fast approximation normaldistribution with
        %these parameters is used. Hypergeometric distributed random
        %numbers are extremely slow
        [mean, var] = hygestat(N(x),I(x),tot_T(i));
        
        %This calculates how many infected travel from x to y
        T(i,1) = abs(round(randn*sqrt(var) + mean));
        
        %hygestat cannot calculate hygestat(N(x),N(x),tot_T(i)) so this has
        %to be calculated seperately
    elseif I(x) == N(x)
        
        T(i,1) = tot_T(i);
        
    else
        
        T(i,1) = 0;
        
    end
    
    %Same as before but in the backwards direction
    if I(y) < N(y) && I(y) > 0
        
        [mean, var] = hygestat(N(y),I(y),tot_T(i));
        T(i,2) = abs(round(randn*sqrt(var) + mean));
        
    elseif I(y) == N(y)
        
        T(i,2) = tot_T(i);
        
    else
        
        T(i,2) = 0;
        
    end
    
    %Calculate number of infected in city x as: Infected(last tick) +
    %Infected travelling to this city - Infected travelling away from this
    %city
    I(x) = I(x) + T(i,2) - T(i,1);
    
    %Same for city y
    I(y) = I(y) + T(i,1) - T(i,2);
    
    %Because of the approximations more than total number of inhabitants of
    %a city can travel, which has to be corrected. Also the total amount of
    %infected in a city can become bigger than the total number of
    %inhabitants.
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

%Update cities matrix
cities(:,3) = I;

end

function generate_output(output_array, tot_pop, cities, root,edges,b)
%% Function which generates the relevant output

%Generate b (counter in the parfor loop) as a string for later filename
bstr = int2str(b);

%%
%Calculate and produce file for number of cities with at least 10% infected
%with respect to the time. Additionally calculate the ratio of globlal
%infected to total population with respect to the time.

%Initialization
percent_10_infected(length(output_array(1,:)))=0;
ratio(length(output_array(1,:)))=0;

%Go through all data points and allway calculate sums over all cities
for i = 1:length(output_array(1,:))
    percent_10_infected(i)=0;
    
    %Ratio contains the ratio of infected to total population
    ratio(i) = sum(output_array(:,i))/tot_pop;
    
    %Calculate the number of cities with at least 10% infected
    for g = 1:length(output_array(:,1))
        if output_array(g,i)/cities(g,2) >= 0.1
            percent_10_infected(i) = percent_10_infected(i) + 1;
        end
    end
end

%Create continuous filenames so no file will be overwritten when run on
%several computers. Then save files for the different experiments
percent_corr_name='percent_10_total_000.txt';
percent_corr_name(21-length(bstr):20)=bstr;
dlmwrite(percent_corr_name,percent_10_infected);
ratio_2nd_name='ratio_2nd_000.txt';
ratio_2nd_name(14-length(bstr):13)=bstr;
dlmwrite(ratio_2nd_name,ratio);

%For the distance correlation another output was used
% ---
% output_degree(1) = distance;
% output_degree(2) = t;
% degree_corr_name='degre5_corr000.txt';
% degree_corr_name(15-length(bstr):14)=bstr;
% dlmwrite(degree_corr_name,output_degree);
% ---

%For the degree correlation other values had to be calculated and the
%output was altered, too. With the function below the degree of the
%root node and the 1st generation connected nodes are calculated and taken
%as an output.
% ---
% connections = find(edges == root);
% tot_degree = cities(root,1);
% for i = 1:length(connections)
%     if connections(i) > length(edges)
%         connections(i) = connections(i) - length(edges);
%     end
%     if edges(connections(i),1) == root
%         working_node = edges(connections(i),2);
%     else
%         working_node = edges(connections(i),1);
%     end
%     tot_degree = tot_degree + cities(working_node,1);
% end
% output_degree(1) = tot_degree;
% output_degree(2) = t;
% degree_corr_name='degre7_corr000.txt';
% degree_corr_name(15-length(bstr):14)=bstr;
% dlmwrite(degree_corr_name,output_degree);
%---

end