% Test of transport function along the edges of the network

% Feed function with cities matrix (col1: city ID; col2: S; col3: I)
cities0 = [1 50 50;
    2 100 0;
    3 100 0;
    4 100 0];

% edges matrix (col1 and col2: IDs of connected cities)
edges = [1 2;
    1 3;
    2 4];

% These two matrices will come from the network

dt = 2;

tot_T = generate_fixed_tot_T(cities0,edges,dt)

for t = 1:100
    
    if t == 1
        cities = cities0;
    end
    
    [S_T, I_T] = transport_with_fixed_tot_T(cities,edges,tot_T)
    
    cities(:,2) = cities(:,2) + S_T;
    cities(:,3) = cities(:,3) + I_T;
    N = cities(:,2) + cities(:,3)
    
    clear S_T I_T
    
    plot(t,cities(:,2),t,cities(:,3),t,N,'*r'); hold on
end