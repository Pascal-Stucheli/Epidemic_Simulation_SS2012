function tot_T = generate_fixed_tot_T(cities,edges,dt)
%% Function which calculates the number of travellers along every edge.

k = cities(:,1); % degree

N = cities(:,2); % Total population
I = cities(:,3); % Infected

% Calculate the mean of degree in the network
k_mean = mean(k);

% Timefactor
tf = dt/24;

for	i = 1:length(edges)
    
    %For better overview define x as city 1 in the edges matrix and y as
    %city 2 in the edges matrix
    x = edges(i,1);
    y = edges(i,2);
    
    % We weight the transport along an edge with the degrees of the cities. 
    % This is due our assumption that the plublic transport to cities with
    % many connection (e.g. big station or airport) must be high.
    trsp_xy = (k(x)+k(y))/k_mean * tf; % factor scaled with degrees.
    
    % We take the population of the smaller cities to determine the total
    % number of voyagers to avoid that a small city has more leaving
    % voyagers than inhabitants. This is based on our assumption that the 
    % number of voyagers in both direction of an edge must be the same to 
    % keep the population in the cities constant). Scaling with the 
    % reciprocal of the degree of the smaller city ensures that also small
    % cities with high degree do not higher fluxes than citizens.
    if	N(x) < N(y)
        tot_T(i) = round(trsp_xy * 1/k(x) * N(x));
        
    else % would be N(y) < N(x) or N(x) = N(y)
        tot_T(i) = round(trsp_xy * 1/k(y) * N(y));
        
    end
    
end

end
