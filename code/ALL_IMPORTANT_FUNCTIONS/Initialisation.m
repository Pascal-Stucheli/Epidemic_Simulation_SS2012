function[]=Initialisation()

%Summary of the functions needed to create our start network. bcs
%everything needed is stored in .txt or .csv files. -> has only to be
%executed once

%This function generates:   -cities.txt w/o infection
%                           -edges.txt
%                           -network.csv
%                           -tot_T.txt

ncit = 10000; %number of cities in the Network
seeded = [1 5; 2 3; 4 5;4 3];%seed for the edges
seedct = [1 0 0;1 0 0;1 0 0;1 0 0;2 0 0]; %seed for the cities
dt=2; %2hours (timesteps of the simulation) -> needed to scale the 
      %passenger volumina

%Generation of edge and node lists of a network with loops
[cities,edge]=networkepid2loops(ncit,seeded,seedct);

%Generation of the city populations
cities=city_size(cities); %output is cities.txt

%Generation of the traffic volumina on each edge
tot_T = generate_fixed_tot_T(cities,edge,dt);

%Stores the traffic volumina for the simulation. The other data sets were 
%already stored by the functions generating them.
dlmwrite('tot_T.txt',tot_T);

end