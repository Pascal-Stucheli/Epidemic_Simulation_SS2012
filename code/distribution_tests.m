%Stochastic / Random disease outbreak simulation in a city
clear all

hold on
<<<<<<< HEAD
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
        sig_dEdt2 = sqrt(dEdt2);
        
        dEdt1f = -1;
        dEdt2f = -1;
        while dEdt1f < 0 %random number has to be 0 or bigger
            rn = randn; % standard normal random number
            dEdt1f = round((dEdt1*dt+sig_dEdt1*rn));
        end
        while dEdt2f < 0
            rn = randn;
            dEdt2f = round((dEdt2*dt+sig_dEdt2*rn));
        end
        
        E(j+1) = E(j)+dEdt1f-dEdt2f; % I_new = I_old + E(dI)*dt + std(dI)*sqrt(dt)*randn
        I(j+1) = I(j)+dEdt2f;
        t(j+1) = t(j)+dt; % update time
        j=j+1; % uptdate counter
    end
    
    plot(t,I)
    plot(t,E,'r')
end
hold off
