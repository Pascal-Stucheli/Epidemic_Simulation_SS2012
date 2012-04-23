%DEMO DISEASE SPREADING

function demo_disease_spreading %mainfunction to execute everything

clear all;
profile on
%parameter definition

dt = 2; %hours
runtime = 24*7*5; %hours
t = 0; %initialization
meeting_events_mean = 13;%per day
meeting_events_stdev = 13;%per day
infection_prob = 0.08; %infection probability on meeting event

%create demo network
%inhabitants, sick, (connection city, people transfer)
CITIES_ARRAY = [
    100000, 1, 2, 100, 0, 0, 0, 0;
    100000, 0, 1, 100, 3, 100, 0, 0;
    100000, 0, 2, 100, 4, 50, 0, 0;
    100000, 0, 3, 50, 0, 0, 0, 0];

%main step runs through the whole time
hold on
while t < runtime
    
        
         plot(t,CITIES_ARRAY(2,2),'.b')
    %     plot(t/24,CITIES_ARRAY(3,2),'.g')
    %     plot(t/24,CITIES_ARRAY(4,2),'.y')
    %
    %1. Step Traffic
    
    %CITIES_ARRAY = Simulate_Traffic(CITIES_ARRAY,dt);
    
    %2. Step Infection
    
    CITIES_ARRAY = Simulate_Infection(CITIES_ARRAY,dt,meeting_events_mean,meeting_events_stdev,infection_prob,t);
    
    % Time update
    CITIES_ARRAY(1,2)
    plot(t,CITIES_ARRAY(1,2),'.r')
    t = t + dt
end
hold off

profile viewer
end

function CITIES_ARRAY = Simulate_Traffic(CITIES_ARRAY,dt)

for n = 1:length(CITIES_ARRAY(:,1)) %simulate traffic for each city
    g = 4; %set array position where connection information starts
    while g <= length(CITIES_ARRAY(1,:)) && CITIES_ARRAY(n,g) > 0 && CITIES_ARRAY(n,2) > 0
        if CITIES_ARRAY(n,2) > 0 %if there are any infected
            %-------------------------------------------------------------------------------------------------------------------------------------------------
            travelling_infected = hygernd(CITIES_ARRAY(n,1),CITIES_ARRAY(n,2),round(CITIES_ARRAY(n,g)/24*dt));
            %hygernd(people city a, infected city a, travelling people per time
            %interval)
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
    if infected > 0 && susceptible > 0
        meeting_events = -1; %total number of meeting events
        while meeting_events < 0 %no negative number of meetings allowed
            meeting_events = round(randn*infected*meetings_stdev + meetings_mean*infected); %sum of randn can be added like this
        end
        if meeting_events > 0 %further calculation only if meetings happen
            meeting_susceptible = binornd(meeting_events,susceptible/CITIES_ARRAY(n,1)); %probability can be combined in just one binornd
            if meeting_susceptible > 0
                min_meeting_per_sus = floor(meeting_susceptible/susceptible);
                sus_meeting_max = meeting_susceptible - min_meeting_per_sus*susceptible;
                sus_meeting_min = susceptible - sus_meeting_max;
                dI1 = binornd(sus_meeting_min,1-(1-infection_prob)^min_meeting_per_sus);
                dI2 = binornd(sus_meeting_max,1-(1-infection_prob)^(1+min_meeting_per_sus));
                dI = dI1 + dI2;
            else dI = 0;
            end
        else dI = 0;
        end
        CITIES_ARRAY(n,2)  = CITIES_ARRAY(n,2) + dI;
        if CITIES_ARRAY(n,2) > CITIES_ARRAY(n,1) %not more infected possible than whole population
            CITIES_ARRAY(n,2) = CITIES_ARRAY(n,1);
        end
    end
end

end