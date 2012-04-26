function cities = transport_with_fixed_tot_T(cities,edges,tot_T)
% This function is meant to be the interface between the network and the disease simulation.

I = cities(:,3); % Infected
N = cities(:,2); % Total population
S = cities(:,2)-I; % Susceptibles

% Transport matrix
T = zeros(length(edges(:,2)),2); 	% col1: Infected voyagers going x -> y; col2: Infected voyagers going y -> x)

% Change-of-population-caused-by-transport vector
S_T = zeros(length(cities(:,3)),1);
I_T = zeros(length(cities(:,3)),1);

for	i = 1:length(edges)
    
    x = edges(i,1); % It is not necessary to define x and y but it may helps with the overview
    y = edges(i,2);
    
    % in order to reduce unused computational efforts -> only calculate transport if at
    %least one city at the end of the edge has infected people.
if I(y) > N(y) | I(x) > N(x) | I(x) < 0 | I(y) < 0 | N(x) < 0 | N(y) < 0 
%    I(x)
%    cities(x,3)
%    I(y)
%    cities(y,3)
%    N(x)
%    N(y)
end
     if I(x) | I(y) > 0
        
        % We assume that the number of infected voyagers is binomial distributed with n = T(i,1) and p = I(x or y)/N(x or y)
        %
        T(i,1) = binornd(tot_T(i),I(x)/N(x)); % Infected voyagers traveling from x to y.
        T(i,2) = binornd(tot_T(i),I(y)/N(y)); % "	     "	      "		"    y to x.
  
    else T(i,:) = 0;
        
    end
    
    % Calculate changes of S and I of city x and y and update.
    
    % Derivation: Sx: Total S of city x, Ix: Total I of city x, TS_x-y:
    % S leaving city x, TI_x-y: I leaving city x. Same for city y, Txy:
    % Total voyagers (= TS_xy + TI_xy)
    % Sx = Sx,old - TS_x-y + TI_y-x = Sx,old - (Txy - TI_x-y) + (Txy -
    % TI_y-x) = Sx,old + TI_x-y - TI_y-x
    %S_T(x) = S_T(x) + T(i,1) - T(i,2);
    I(x) = I(x) + T(i,2) - T(i,1);
    %S_T(y) = S_T(y) + T(i,2) - T(i,1);
    I(y) = I(y) + T(i,1) - T(i,2);
    if I(x) < 0
        I(x) = 0;
    end
    if I(y) < 0
       I(y) = 0;
    end
    clear x y % for next round -> may cause problems & ev. not necessary!!!
    
end

cities(:,3) = I;
   
end