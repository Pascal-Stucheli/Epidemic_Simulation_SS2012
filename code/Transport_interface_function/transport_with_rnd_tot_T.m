function [S_T, I_T] = transport_with_rnd_tot_T(cities,edges,dt)
% This function is meant to be the interface between the network and the disease simulation.

k = cities(:,1); % degree
S = cities(:,2); % Susceptibles
I = cities(:,3); % Infected
N = S + I;	 % Total population

k_mean = mean(k);

% Timefactor
tf = dt/24;

% Transport matrix
T = zeros(length(edges),3); 	% col1: Total voyagers; col2: Infected voyagers going x -> y; col3: Infected voyagers going y -> x)

% Change-of-population-caused-by-transport vector
S_T = zeros(length(cities),1);
I_T = zeros(length(cities),1);



for	i = 1:length(edges)
    
    x = edges(i,1); % It is not necessary to define x and y but it may helps with the overview
    y = edges(i,2);
    
    % We weight the transport along an edge with the degrees of the cities. This is due our
    % assumption that the plublic transport to cities with many connection (e.g. big station or airport)
    % must be high.
    % Introduction of tf or "city-size-factor" necessary? Or scaling with length of edge?
    trsp_xy = (k(x)+k(y))/k_mean * tf; % parameters: tparam = transport parameter (e.g. a fixed percentage)
    
    % in order to reduce unused computational efforts -> only calculate transport if at
    %least one city at the end of the edge has infected people.
    if I(x) | I(y) > 0
        
        % We take the population of the smaller cities to determine the total number of voyagers to avoid that
        % a small city has more leaving voyagers than inhabitants.
        % This is also based on our assumption that the number of voyagers in both direction of an edge is the same (ASSUMPTION 1).
        % (ASSUMPTION 1 is important to keep the population in the cities constant).
        if	N(x) < N(y)
            T(i,1) = round(trsp_xy * N(x) * abs(1+randn)); % positive normal distributed random variable -> abs ok???
            
        else % would be N(y) < N(x) or N(x) = N(y)
            T(i,1) = round(trsp_xy * N(y) * abs(1+randn));
            
        end
        
        % We assume that the number of infected voyagers is binomial distributed with n = T(i,1) and p = I(x or y)/N(x or y)
        %
        T(i,2) = binornd(T(i,1),I(x)/N(x)); % Infected voyagers traveling from x to y.
        T(i,3) = binornd(T(i,1),I(y)/N(y)); % "	     "	      "		"    y to x.
        
    else T(i,:) = 0;
        
    end
    
    % Calculate changes of S and I of city x and y and update.
    
    % Derivation: Sx: Total S of city x, Ix: Total I of city x, TS_x-y:
    % S leaving city x, TI_x-y: I leaving city x. Same for city y, Txy:
    % Total voyagers (= TS_xy + TI_xy)
    % Sx = Sx,old - TS_x-y + TI_y-x = Sx,old - (Txy - TI_x-y) + (Txy -
    % TI_y-x) = Sx,old + TI_x-y - TI_y-x
    S_T(x) = S_T(x) + T(i,2) - T(i,3);
    I_T(x) = I_T(x) + T(i,3) - T(i,2);
    
    S_T(y) = S_T(y) + T(i,3) - T(i,2);
    I_T(y) = I_T(y) + T(i,2) - T(i,3);
    
    clear x y % for next round -> may cause problems & ev. not necessary!!!
    
end

end