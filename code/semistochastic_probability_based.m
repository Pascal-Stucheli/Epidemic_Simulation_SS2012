%Disease spreading SI model

clear all
hold on
for i = 1:100
    t(1) = 0;
    tend = 24*7*2; %endtime hours
    dt = 1; %timesteps in hours
    counter = 1;
    
    N = 10000; %population
    I(1) = 1; %I of puopulation are sick
    meetings_stdev = 13/24*dt; %66 percent of meetings par day are in mean +- stdev range
    meetings_mean = 13/24*dt; %meetings per day calculated to dt proportional
    inf_prob = 0.08; %infection probability on meeting event
    
    while t(counter) < tend %simulate for whole time
        
        %calculate the total numbers of meeting events
        mtt = 0; %total number of meeting events
        for it = 1:I(counter)
            randpart = -1;
            while randpart < 0 %randompart hast to be >= 0
                randpart = round(randn*meetings_stdev + meetings_mean); %normally distributed random part
            end
            mtt = mtt + randpart;
        end
        
        %calculate how many of the meeting events happened to Susceptible
        if mtt > 0 %further calculation only if meetings happen
            mtS = binornd(mtt,(N-I(counter))/N);
            
            %calculate how many of the meetings result in an infection
            if mtS > 0 %further calculation only if meetings happen
                dI = binornd(mtS, inf_prob);
            else dI = 0;
            end
            
        else dI = 0;
        end
        
        I(counter + 1) = I(counter) + dI; %update number of infected
        
        if I(counter + 1) > N %not more infected possible than whole population
            I(counter + 1) = N;
        end
        
        t(counter + 1) = t(counter) + dt;
        counter = counter + 1; %counter and time update
        
    end
    
    plot(t,I)
    meanI(i,:) = I;
    
end
hold off
plot(t,mean(meanI),'r')


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