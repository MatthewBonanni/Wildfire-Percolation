function neighbors = get_neighbors(location, stencil, fieldSize)
%FIND_NEIGHBORS Returns list of index sets of neighbors of given point
%   Determines the neighborhood for a given point using the given stencil.
%   Implements periodic boundary conditions

% Center stencil at location
neighbors = [stencil(:,1) + location(1), stencil(:,2) + location(2)];

% Implement periodic boundary condition
neighbors(neighbors <= 0) = ...
    neighbors(neighbors <= 0) + fieldSize;
neighbors(neighbors > fieldSize) = ...
    neighbors(neighbors > fieldSize) - fieldSize;

end