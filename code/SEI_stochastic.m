%Stochastic / Random disease outbreak simulation in a city
clear all

hold on
for i = 1:2
    i
    
    %parameter definition
    N = 10000; %population
    dt = 60; %mins
    beta = 0.002; %contact rate
    eps = 1/(24*60); %average latent period = 1/eps
    endtime = 24*60*2; %minutes
    
    %initialization
    j = 1;
    t(j) = 0;
    I(j) = 1; %infected
    E(j) = 0; %E are in a latent incubation phase
    
    while t(j)<endtime
        dEdt1 = beta*I(j)*(N-I(j)-E(j))/N; % see pdf for derivation (p. 20-25)
        sig_dEdt1 = sqrt(dEdt1);
        dEdt2 = E(j)*eps;
        if dEdt2 > E(j)
            dEdt2 = E(j);
        end
        sig_dEdt2 = sqrt(dEdt2);
        
        dEdt1f = -1;
        dEdt2f = -1;
        while dEdt1f < 0 %random number has to be 0 or bigger
            rn = randn; % standard normal random number
            dEdt1f = round((dEdt1*dt+sig_dEdt1*rn*sqrt(dt)));
        end
        while dEdt2f < 0
            rn = randn;
            dEdt2f = round((dEdt2*dt+sig_dEdt2*rn*sqrt(dt)));
        end
        
        E(j+1) = E(j)+dEdt1f-dEdt2f; % I_new = I_old + E(dI)*dt + std(dI)*sqrt(dt)*randn
        I(j+1) = I(j)+dEdt2f;
        t(j+1) = t(j)+dt; % update time
        j=j+1; % uptdate counter
    end
    
    plot(t,I,'b')
    plot(t,E,'r')
end
hold off