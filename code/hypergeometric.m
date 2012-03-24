function hypergeometric
%Hypergeometric testfunction
clear all

for X = 1:365 %for a whole year
num_items = 10000; %number of city inhabitants
num_desired = 200; %number of sick
draws = 200; %number of flights

x(X)=hygeinv(rand,num_items,num_desired,draws); %number of flying sick
%hypergeometrical distribution used, principle of having num_items balls
%from which num_desired are black and you take draws balls out without
%laying back and you look how many have been black. same used for looking
%how many sick persons flew with an airplane. hygeinv is the inverse of the
%cumulative distribution function. if you take a random number between 0
%and 1 for the probability then it says you how many sick people flew with
%this distribution. i think it works and so not every single sick person
%has to be calculated
end
figure(1)
plot(1:X,x,'.')
figure(2)
hist(x,10)
end