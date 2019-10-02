function neighbors = get_neighbors(location, stencil, fieldSize)
%FIND_NEIGHBORS Returns list of index sets of neighbors of given point
%   Determines the neighborhood for a given point using the given stencil.
%   Implements periodic boundary conditions

% Center stencil at location
neighbors = [stencil(:,1) + location(1), stencil(:,2) + location(2)];

% Implement lateral periodic boundary condition

neighbors((neighbors(:,2) <= 0), 2) = ...
    neighbors((neighbors(:,2) <= 0), 2) + fieldSize;

neighbors((neighbors(:,2) > fieldSize), 2) = ...
    neighbors((neighbors(:,2) > fieldSize), 2) - fieldSize;

% Implement bottom and top wall boundary conditions

neighbors = neighbors(~(neighbors(:,1) <= 0), :);
neighbors = neighbors(~(neighbors(:,1) > fieldSize), :);

end