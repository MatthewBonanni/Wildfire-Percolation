function stencil = get_stencil(neighborhoodSize)
%GET_stencil Determine the neighborhood stencil for a given size
%   The stencil is the set of neighboring grid points to check for burn
%   status

% Empty array to fill with index sets and their distances
distArray = [];

% Iterate through xy offsets
for x = 1:neighborhoodSize
    for y = 0:x
        
        % Compute distance to origin and fill distArray
        distArray = vertcat(distArray, [x, y, norm([x, y])]);
    end
end

% Sort by distance to origin
distArray_sorted = sortrows(distArray,3);

% Select desired closest number of neighbors
stencil = distArray_sorted(1:neighborhoodSize, 1:2);

% Add reflection points
stencil = vertcat(stencil, [ stencil(:,2),  stencil(:,1)]); % y=x
stencil = vertcat(stencil, [ stencil(:,1), -stencil(:,2)]); % y=0
stencil = vertcat(stencil, [-stencil(:,1),  stencil(:,2)]); % x=0

% Remove duplicates created by reflection
stencil = unique(stencil, 'rows');

end