% Stochastic Differential Equation
% SIS Epidemic Model
% Sample Paths and the Deterministic Solution

clear all

beta=1; % contact rate
b=0.25; % birth rate
gam=0.25; % [infectious periode]^-1
N=100;
init=2; % initialize with 2 infectives
dt=0.01; % time step
time=25;
sim=4; % number of simulations
for k=1:sim
    clear i
    j=1;
    i(j)=init;
    t(j)=dt;
    while i(j)>0 & t(j)<25
        mu=beta*i(j)*(N-i(j))/N-(b+gam)*i(j); % see pdf for derivation (p. 20-25)
        sigma=sqrt(beta*i(j)*(N-i(j))/N+(b+gam)*i(j));
        rn=randn; % standard normal random number
        i(j+1)=i(j)+mu*dt+sigma*sqrt(dt)*rn; % I_new = I_old + E(dI)*dt + std(dI)*sqrt(dt)*randn
        t(j+1)=t(j)+dt; % update time
        j=j+1; % uptdate counter
    end
    plot(t,i,'r-','Linewidth',2);
    hold on
    
end

% Euler’s method applied to the deterministic SIS model.
% (dashed black line in the plot)
y(1)=init;
for k=1:time/dt
    y(k+1)=y(k)+dt*(beta*(N-y(k))*y(k)/N-(b+gam)*y(k));
end
plot([0:dt:time],y,'k--','LineWidth',2);
axis([0,time,0,80]);
xlabel('Time');
ylabel('Number of Infectives');
hold off