%Stochastic / Random disease outbreak simulation in a city
clear all

hold on
for i = 1:10
    i
    Stot = 10000;
    S = Stot;
    I = 1;
    for t = 1:1:24*365 %each step one hour
        if S > 0
            M = 0; %M is number of meetings with healthy people that occured in 1 hour totally
            meetings_tot = 0;
            %the number of total meetings is rounded, abs, normally distributed
            %with mean 6 and stdev 2. how many of this meetings happen with healthy
            %is hypergeometrically distributed. how many of those meetings will end
            %in an infection is binomial distributed.  
            for i = 1:I
                meetings_tot = meetings_tot + round(abs(randn*2+2)); %this consumes allmost no time
                %calculate normaldistribution of meeting counters
                %then with this calculate hypergeometric distributed randomnumber of
                %meetings with healthy.
            end
            if meetings_tot == 0
                M = 0;
            else
                M = round(binornd(meetings_tot,S/Stot)); %this consumes much time
            end
            
            dI = binornd(M,0.05);
            if dI > S
                dI = S;
            end
            I = I+dI;
            S = S-dI;
        end
        plot(t,I,'.b','MarkerSize',5)
        %plot(t,S,'.r')
    end
end
hold off


%as it seems 10x hypergeometric distributed randomvariables added is the
%same as: hygernd(10*,10*,10*)