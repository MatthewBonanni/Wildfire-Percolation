% Matthew Bonanni
% Stanford University
% Ihme Group
% Autumn 2019

% Albinet et al 1986 dynamic percolation model
% Implementation based on Beer, Enting 1990

%% State Definitions

% 0 - Unburnable
% 1 - Burned
% 2 + h - Burnable, with heat content h
% 100 + d - Burning for duration d

%% Field parameters

fieldSize = 100;
neighborhoodSize = 4;
burnDuration = 3;
ignitionThreshold = 3;
burnable_p = 0.3;

%% Initialize random field

init = rand(fieldSize);

field = zeros(fieldSize);
field(init <= burnable_p) = 2;
field(init > burnable_p) = 0;

%% Ignite trees in bottom two rows

initFire = field == 2;
initFire(1:end-2,:) = 0;

field(initFire) = 100;

% Initialize video recording and plot initial state
v = VideoWriter('percolation', 'MPEG-4');
open(v);
plot_field(field);

%% Compute fire spread stencil

stencil = get_stencil(neighborhoodSize);

%% Time stepping

exhausted = 0;
penetrated = 0;
duration = 0;

nextField = field;

while ~(exhausted || penetrated)
    
    change = 0;
    
    % Iterate through all locations
    for i = 1:fieldSize
        for j = 1:fieldSize
            
            % If unburnable or burnt, ignore
            if field(i,j) < 2
                continue;
            end
            
            % If burning, advance burn time or burn out
            if field(i,j) >= 100
                if field(i,j) - 100 >= burnDuration
                    nextField(i,j) = 1;
                    continue;
                else
                    nextField(i,j) = field(i,j) + 1;
                    continue;
                end
            end
            
            % Check template for number of burning neighbors
            neighbors = get_neighbors([i,j], stencil, fieldSize);
            neighbors_lin = sub2ind(size(field), neighbors(:,1), neighbors(:,2));
            nbn = sum(field(neighbors_lin) >= 100);
            
            % Start burning if ignition threshold reached
            if nbn + field(i,j) - 2 >= ignitionThreshold
                nextField(i,j) = 100;
                continue;
            else % Add heat
                nextField(i,j) = nextField(i,j) + nbn;
                continue;
            end
        end
    end
    
    % Check exhaustion and penetration conditions
    if ~any(field >= 100, 'all')
        exhausted = 1;
    elseif any(field(1,:) >= 100, 'all')
        penetrated = 1;
    end
    
    field = nextField;
    duration = duration + 1;
    
    plot_field(field);
    writeVideo(v, getframe(gcf));
    
    pause(0.05);
end

close(v);

if exhausted
    unburned = sum(field >= 2 & field < 100);
    burned = sum(field == 1);
    
    burnFraction = burned / (unburned + burned);
    
    disp("Fraction of available material burned:");
    disp(burnFraction);
else
    disp("Penetration condition reached");
end

disp("Fire duration:");
disp(duration);