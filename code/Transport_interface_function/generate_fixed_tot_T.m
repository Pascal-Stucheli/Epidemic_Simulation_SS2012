function tot_T = generate_fixed_tot_T(cities,edges,dt)
% This function is meant to be the interface between the network and the disease simulation.

k = cities(:,1); % degree

N = cities(:,2); % Total population
I = cities(:,3); % Infected
S = N - I;	 % Total p

k_mean = mean(k);

% Timefactor
tf = dt/24;

% Transport matrix
T = zeros(length(edges),2); % col1: Infected voyagers going x -> y; col2: Infected voyagers going y -> x)

for	i = 1:length(edges)
    
    x = edges(i,1); % It is not necessary to define x and y but it may helps with the overview
    y = edges(i,2);
    
    % We weight the transport along an edge with the degrees of the cities. This is due our
    % assumption that the plublic transport to cities with many connection (e.g. big station or airport)
    % must be high.
    % Introduction of tf or "city-size-factor" necessary? Or scaling with length of edge?
    trsp_xy = (k(x)+k(y))/k_mean * tf; % parameters: tparam = transport parameter (e.g. a fixed percentage)
    
    % We take the population of the smaller cities to determine the total number of voyagers to avoid that
    % a small city has more leaving voyagers than inhabitants.
    % This is also based on our assumption that the number of voyagers in both direction of an edge is the same (ASSUMPTION 1).
    % (ASSUMPTION 1 is important to keep the population in the cities constant).
    if	N(x) < N(y)
        tot_T(i) = round(trsp_xy * N(x));
        
    else % would be N(y) < N(x) or N(x) = N(y)
        tot_T(i) = round(trsp_xy * N(y));
        
    end
    
end

end
