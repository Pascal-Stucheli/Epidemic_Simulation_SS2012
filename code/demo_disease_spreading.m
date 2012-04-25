%DEMO DISEASE SPREADING

function outputvar = demo_disease_spreading %mainfunction to execute everything

clear all;
%profile on
%parameter definition

dt = 2; %hours
runtime = 24*7*8; %hours
t = 0; %initialization
meeting_events_mean = 13;%per day
meeting_events_stdev = 13;%per day
infection_prob = 0.08; %infection probability on meeting event

%create demo network
%inhabitants, sick, (connection city, people transfer)
CITIES_ARRAY = [
    100000, 1, 2, 10, 3, 10, 5, 10;
    100000, 0, 1, 10, 4, 10, 0, 0;
    100000, 0, 1, 10, 4, 10, 0, 0;
    100000, 0, 2, 10, 3, 10, 0, 0;
    100000, 0, 1, 10, 6, 10, 0, 0;
    100000, 0, 5, 10, 7, 10, 0, 0;
    100000, 0, 6, 10, 8, 10, 0, 0;
    100000, 0, 7, 10, 9, 10, 0, 0;
    100000, 0, 8, 10, 0, 0, 0, 0];

%main step runs through the whole time
g = 1;
while t < runtime
    
    outputvar{1}(:,g) = CITIES_ARRAY(:,1);
    outputvar{2}(:,g) = CITIES_ARRAY(:,2);
    outputvar{3}(1,g) = t;
     
    %1. Step Traffic
    
    CITIES_ARRAY = Simulate_Traffic(CITIES_ARRAY,dt);
    
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

meetings_stdev = meeting_events_stdev/24*dt; %66 percent of meetings par day are in mean +- stdev range
meetings_mean = meeting_events_mean/24*dt; %meetings per day calculated to dt proportional

for n = 1:length(CITIES_ARRAY(:,1))
    infected = CITIES_ARRAY(n,2);
    susceptible = (CITIES_ARRAY(n,1)-infected);
    
    if infected > 0 && susceptible > 0 %don't go on if there are no infected or no susceptibles left
        meeting_events = round(abs(randn*meetings_stdev*infected + meetings_mean*infected)); %calculate the meeting events
        dI = binornd(meeting_events, infection_prob*susceptible/(susceptible+infected)); %approximate how many of these meetings result in an infection
        %probability = infection_prob*part of susceptible in population
        %not approximated method attached in the end
        CITIES_ARRAY(n,2)  = infected+dI; %update population
        if CITIES_ARRAY(n,2) > CITIES_ARRAY(n,1) %not more infected possible than whole population
            CITIES_ARRAY(n,2) = CITIES_ARRAY(n,1);
        end
    end
end

end

%non-approximated method for infection spreading
%         for i = 1:infected
%
%            meeting_events = round(abs(randn*meetings_stdev + meetings_mean));
%             if meeting_events > 0
%
%                 for m = 1:meeting_events
%                     if susceptible > 0;
%                         if rand < susceptible/(infected+susceptible)*infection_prob;
%                             infected = infected + 1;
%                             susceptible = susceptible - 1;
%                         end
%                     end
%                     if susceptible < 1
%                         break
%                     end
%                 end
%            end
%          end
%         if susceptible < 1
%             break
%         end