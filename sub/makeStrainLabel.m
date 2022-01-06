function labelText = makeStrainLabel(pixels, strainLabel)

% Copyright (C) 2022 University of Dundee & Open Microscopy Environment.
% All rights reserved.
% 
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License along
% with this program; if not, write to the Free Software Foundation, Inc.,
% 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

sizeX = pixels.getSizeX.getValue;
startX = sizeX - 80;  %150 for NCBI 3610 and 80 for muts

f = gcf;
ca = f.CurrentAxes;

labelText = annotation('textbox');
labelText.String = strainLabel;
labelText.Color = 'w';
labelText.FontWeight = 'bold';
labelText.LineStyle = 'none';
labelText.FontSize = 20;

[labelText.Position(1), ~] = coord2norm(ca, startX, 0);
labelText.Position(2) = 0.07;