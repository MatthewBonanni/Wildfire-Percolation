% Matthew Bonanni
% Stanford University
% Ihme Group
% Autumn 2019

% Percolation model based on Beer, Enting 1990

%% State Definitions

% 0 - Unburnable
% 1 - Burnable
% 2 - Burnt
% 3 + h - Burning for duration h

%% Field parameters

fieldSize = 100;
neighborhoodSize = 4;
burnDuration = 3;
ignitionThreshold = 3;
burnable_p = 0.5;
initFireSize = 4;

%% Initialize random field

init = rand(fieldSize);

field = zeros(fieldSize);
field(init <= burnable_p) = 1;
field(init > burnable_p) = 0;

%% Start random fire with given size

[burnable_x, burnable_y] = find(field);
burnableCount = length(burnable_x);
fireIndex = randi(burnableCount);
fireSeedLocation = [burnable_x(fireIndex), burnable_y(fireIndex)];

initStencil = get_stencil(initFireSize);
initFire = [fireSeedLocation;
            get_neighbors(fireSeedLocation, initStencil, fieldSize)];

for i = 1:size(initFire,1)
    if field(initFire(i,1), initFire(i,2)) == 1
        field(initFire(i,1), initFire(i,2)) = 3;
    end
end

plot_field(field);

%% Compute fire spread stencil

spreadStencil = get_stencil(neighborhoodSize);

%% Time stepping

fireActive = 1;
duration = 0;

nextField = field;

while fireActive
    
    change = 0;
    
    % Iterate through all locations
    for i = 1:fieldSize
        for j = 1:fieldSize
            
            % If unburnable or burnt, ignore
            if field(i,j) == 0 || field(i,j) == 2
                continue;
            end
            
            % If burning, advance burn time or burn out
            if field(i,j) >= 3
                if field(i,j) - 3 >= burnDuration
                    nextField(i,j) = 2;
                    change = 1;
                    continue;
                else
                    nextField(i,j) = field(i,j) + 1;
                    change = 1;
                    continue;
                end
            end
            
            % Check template for number of burning neighbors
            neighbors = get_neighbors([i,j], spreadStencil, fieldSize);
            neighbors_lin = sub2ind(size(field), neighbors(:,1), neighbors(:,2));
            
            % Start burning if ignition threshold reached
            if sum(field(neighbors_lin) >= 3) >= ignitionThreshold
                nextField(i,j) = 3;
                change = 1;
                continue;
            end
        end
    end
    
    if ~change
        fireActive = 0;
    end
    
    field = nextField;
    duration = duration + 1;
    
    plot_field(field);
    
    pause(0.05);
end

unburned = sum(field == 1);
burned = sum(field == 2);

burnFraction = burned / (unburned + burned);

disp("Fraction of available material burned:");
disp(burnFraction);

disp("Fire duration:");
disp(duration);