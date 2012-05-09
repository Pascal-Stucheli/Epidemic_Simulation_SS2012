function cities = transport_with_fixed_tot_T(cities,edges,tot_T)
% This function is meant to be the interface between the network and the disease simulation.

N = cities(:,2); % Total population
I = cities(:,3); % Infected
S = N-I; % Susceptibles

% Transport matrix
% col1: Infected voyagers going x -> y; col2: Infected voyagers going y -> x
T = zeros(length(edges(:,2)),2);

for i = 1:length(edges)
    
    x = edges(i,1); % It is not necessary to define x and y but it may helps with the overview
    y = edges(i,2);
    
    % in order to reduce unused computational efforts -> only calculate transport if at
    % least one city at the end of the edge has infected people. Also, no
    % transport between fully infected cities.
    
    if I(x) > 0 || I(y) > 0
        
        if N(x) - I(x) ~= 0 && N(y) - I(y) ~= 0
            
            % We assume that the number of infected voyagers is binomial distributed with n = T(i,1) and p = I(x or y)/N(x or y)
            %
            if I(x) > 0
                [mean, var] = hygestat(N(x),I(x),tot_T(i));
                T(i,1) = abs(round(randn*sqrt(var) + mean));
                %T(i,1) = binornd(tot_T(i),I(x)/N(x)); % Infected voyagers traveling from x to y.
            end
            if I(y) > 0
                
                [mean, var] = hygestat(N(y),I(y),tot_T(i));
                T(i,2) = abs(round(randn*sqrt(var) + mean));
            %T(i,2) = binornd(tot_T(i),I(y)/N(y)); % " " " " y to x.
            end
        
            
        else T(i,:) = 0;
            
        end
        
    else T(i,:) = 0;
        
    end
        
        % Calculate changes of S and I of city x and y and update.
        
        % Derivation: Sx: Total S of city x, Ix: Total I of city x, TS_x-y:
        % S leaving city x, TI_x-y: I leaving city x. Same for city y, Txy:
        % Total voyagers (= TS_xy + TI_xy)
        % Sx = Sx,old - TS_x-y + TI_y-x = Sx,old - (Txy - TI_x-y) + (Txy -
        % TI_y-x) = Sx,old + TI_x-y - TI_y-x
        
        %S_T(x) = S_T(x) + T(i,1) - T(i,2);
        I(x) = I(x) + T(i,2) - T(i,1); % Update number of infected in city x
        %S_T(y) = S_T(y) + T(i,2) - T(i,1);
        I(y) = I(y) + T(i,1) - T(i,2); % Update number of infected in city y
        
        % With the binomial assumption a infected person can be drawn more than
        % one time per round, therefore negative I(x or y) must avoided:
        if I(x) < 0
            I(x) = 0;
        end
        
        if I(y) < 0
            I(y) = 0;
        end
        
        if I(x) > N(x)
            I(x)=N(x)
        end
        
         if I(y) > N(y)
            I(y)=N(y)
         end
        
        clear x y % for next round -> may cause problems & ev. not necessary!!!
        
    end
    
    cities(:,3) = I; % Update cities matrix.
    
end