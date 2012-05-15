% Test of transport function along the edges of the network

clear cities cities0 cities1

% Feed function with cities matrix (col1: city ID; col2: S; col3: I)
cities0 = [2 2000 100;  % city 1
    2 2000 0;           % city 2
    1 1000 0;           % city 3
    1 1000 0;           % city 4
    4 10000 0;          % city 5
    1 1000 0;           % city 6
    2 2000 0;           % city 7
    2 2000 0];          % city 8

% edges matrix (col1 and col2: IDs of connected cities)
edges = [1 2;
    1 3;
    2 4
    4 5
    5 6
    5 7
    5 8
    7 8];

% These two matrices will come from the network

dt = 2;

tot_T = generate_fixed_tot_T(cities0,edges,dt)

for t = 1:1000
    
    if t == 1
        cities = cities0;
    end
    
    cities1 = transport_with_fixed_tot_T(cities,edges,tot_T)
    
    plot(t,cities1(:,3),'-.','MarkerSize',8); hold on
    
end
legend('city1','city2','city3','city4','city5','city6','city7','city8'); 
hold off
