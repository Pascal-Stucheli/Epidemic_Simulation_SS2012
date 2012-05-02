% Final Simulation

function FINAL_SIMULATION

clear all
profile on

%load network

% cities = [degree, Stotal, I;....]
% edges = [city A, city B]

cities = dlmread('cities.txt');
cities(1,3)=1;
edges = dlmread('edges.txt');
tot_T = dlmread('tot_T.txt');


%parameter definition
dt = 2; %hours
tot_T = round(tot_T/24/100*dt);
runtime = 24*7*1; %hours
t = 0; %initialization
meeting_events_mean = 13;%per day
meeting_events_stdev = 13;%per day
infection_prob = 0.05; %infection probability on meeting event
g = 1;
output_array = zeros(length(cities(:,1)),runtime/dt);

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

out_file_name = 'outt.txt';
out_file_name(4) = int2str(5);
dlmwrite(out_file_name,output_array);

profile viewer

hold on
for i = 1:100
plot(output_array(i,:),'b')
end
hold off

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
                    
                else %if infected > 1000 deterministic approximation
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
