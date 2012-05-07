%DEMO DISEASE SPREADING

function outputvar = demo_disease_spreading %mainfunction to execute everything

clear all;
%profile on
%parameter definition

dt = 2; %hours
runtime = 24*7*7; %hours
t = 0; %initialization
meeting_events_mean = 7.5;%per day
meeting_events_stdev = 7;%per day
infection_prob = 0.01; %infection probability on meeting event

%create demo network
%inhabitants, sick, (connection city, people transfer)
CITIES_ARRAY = [
    0,100000, 50, 2, 10, 3, 10, 5, 10;
    0,100000, 0, 1, 10, 4, 10, 0, 0;
    0,100000, 0, 1, 10, 4, 10, 0, 0;
    0,100000, 0, 2, 10, 3, 10, 0, 0;
    0,100000, 0, 1, 10, 6, 10, 0, 0;
    0,100000, 0, 5, 10, 7, 10, 0, 0;
    0,100000, 0, 6, 10, 8, 10, 0, 0;
    0,100000, 0, 7, 10, 9, 10, 0, 0;
    0,100000, 0, 8, 10, 0, 0, 0, 0];

%main step runs through the whole time
g = 1;
while t < runtime
    
    outputvar{1}(:,g) = CITIES_ARRAY(:,2);
    outputvar{2}(:,g) = CITIES_ARRAY(:,3);
    outputvar{3}(1,g) = t;
     
    %1. Step Traffic
    
    %CITIES_ARRAY = Simulate_Traffic(CITIES_ARRAY,dt);
    
    %2. Step Infection
    
    CITIES_ARRAY = Simulate_Infection(CITIES_ARRAY,dt,meeting_events_mean,meeting_events_stdev,infection_prob,t);
    
    % Time update
        
    t = t + dt;
    g = g +1;
end

% hold on
% for i = 1:length(outputvar{1}(:,1))
% plot(outputvar{3},outputvar{2}(i,:))
% end
% hold off
% profile viewer
end

function CITIES_ARRAY = Simulate_Traffic(CITIES_ARRAY,dt)

for n = 1:length(CITIES_ARRAY(:,1)) %simulate traffic for each city
    g = 4; %set array position where connection information starts
    while g <= length(CITIES_ARRAY(1,:)) && CITIES_ARRAY(n,g) > 0
        if CITIES_ARRAY(n,2) > 0 %if there are any infected
            travelling_infected = binornd(round(CITIES_ARRAY(n,g)/24*dt),CITIES_ARRAY(n,2)/CITIES_ARRAY(n,1));
            if travelling_infected > CITIES_ARRAY(n,g)
               travelling_infected = CITIES_ARRAY(n,g);
            end
            CITIES_ARRAY(CITIES_ARRAY(n,g-1),2) = CITIES_ARRAY(CITIES_ARRAY(n,g-1),2) + travelling_infected;
            CITIES_ARRAY(n,2) = CITIES_ARRAY(n,2) - travelling_infected;
            %update infected population
        else
            travelling_infected = 0;
        end
        CITIES_ARRAY(CITIES_ARRAY(n,g-1),1) = CITIES_ARRAY(CITIES_ARRAY(n,g-1),1) + round(CITIES_ARRAY(n,g)/24*dt);
        CITIES_ARRAY(n,1) = CITIES_ARRAY(n,1) - round(CITIES_ARRAY(n,g)/24*dt);
        %update total population
        %update total population
        g = g + 2;
    end
end
end

function CITIES_ARRAY = Simulate_Infection(CITIES_ARRAY,dt,meeting_events_mean,meeting_events_stdev,infection_prob,t)

cities = CITIES_ARRAY;
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
CITIES_ARRAY = cities;
end
