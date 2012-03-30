%Disease spreading SI model

clear all
hold on
for i = 1:1
   
    %% Initialization
    t(1) = 0;
    tend = 24*2; %endtime in hours
    dt = 1; %timesteps in hours
    counter = 1;
    
    N = 10000; %population
    I(1) = 1; %I of puopulation are sick
    meetings_stdev = 13/24*dt; %66 percent of meetings par day are in mean +- stdev range
    meetings_mean = 13/24*dt; %meetings per day calculated to dt proportional
    inf_prob = 0.08; %infection probability on meeting event
    %%
    
    while t(counter) < tend %simulate for whole time
        %% calculate the total numbers of meeting events
        
        mtt = -1; %total number of meeting events
        while mtt < 0 %no negative number of meetings allowed
        mtt = round(randn*I(counter)*meetings_stdev + meetings_mean*I(counter)); %sum of randn can be added like this
        end
            
        %% calculate how many of the meeting events happened to Susceptible and how many of them 
        %really got infected
        
        if mtt > 0 %further calculation only if meetings happen
            dI = binornd(mtt,((N-I(counter))/N)*inf_prob); %probability can be combined in just one binornd
            %to calculate how many of the meetings happen to Susceptible
            %AND how many of those got infected
            
            % ----->>>> term missing for multiple infections of one person
            % what is the chance that an infection got on a person which
            % already got infected. 0 for first, 1/S for second 2/S for
            % third.... I don't know how to approximate this. I think this
            % combined probability is not binomial but hypergeometric.
            % because you don't lay it back after you have taken it. each
            % meeting which causes an infection to happen will be taken
            % away.
            
        else dI = 0;
        end
        
        %% Update and plot
        
        I(counter + 1) = I(counter) + dI; %update number of infected
        
        if I(counter + 1) > N %not more infected possible than whole population
            I(counter + 1) = N;
        end
        
        t(counter + 1) = t(counter) + dt;
        counter = counter + 1; %counter and time update
        
    end
    
    plot(t,I,'b')
   % meanI(i,:) = I;
    
end

%plot(t,mean(meanI),'r')
hold off

%% Appendix


% function to test the distribution of random normal distribution
% for q = 1:10000
% randpartt(q) = 0;
% for j = 1:24
% randparttt = -1;
% while randparttt < 0 %randompart hast to be >= 0
%             randparttt = round(randn*meetings_stdev + meetings_mean); %normally distributed random part
%         end
% randpartt(q) = randpartt(q) + randparttt;
% end
% end
% hist(randpartt,100)