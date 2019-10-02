function plot_field(field)
%PLOT_FIELD Plots the given field
%   Color legend:
%   White   Unburnable
%   Green   Burnable
%   Red     Burning
%   Black   Burnt

fieldSize = size(field, 1);

field_im_r = zeros(fieldSize) + 255;
field_im_g = zeros(fieldSize) + 255;
field_im_b = zeros(fieldSize) + 255;

% Set burnt regions

field_im_r(field == 1) = 0;
field_im_g(field == 1) = 0;
field_im_b(field == 1) = 0;

% Set burnable regions

field_im_r(field >= 2 & field < 100) = 0;
field_im_g(field >= 2 & field < 100) = 255;
field_im_b(field >= 2 & field < 100) = 0;

% Set burning regions

field_im_r(field >= 100) = 255;
field_im_g(field >= 100) = 0;
field_im_b(field >= 100) = 0;

field_im = cat(3, field_im_r, field_im_g, field_im_b);

image(field_im)
axis equal
axis off

end