function [l, tb] = makeScaleBar(pixels, scaleBarLength)
%Generate a scale bar object to be added to images or movies. Scale is in
%microns (scaleBarLength). Length of bar in pixels is calculated.

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


physX = pixels.getPhysicalSizeX.getValue;
sizeX = pixels.getSizeX.getValue;

f = gcf;
ca = f.CurrentAxes;

barPixelLength = scaleBarLength / physX;
endX = sizeX - 10;
startX = endX - barPixelLength;
ly = 30;
by = 0;


l = annotation('line');
l.Color = 'w';
l.LineWidth = 4;
[l.X(1), l.Y(1)] = coord2norm(ca, startX, ly);
[l.X(2), l.Y(2)] = coord2norm(ca, endX, ly);


tb = annotation('textbox');
tb.String = num2str(scaleBarLength) + " \mum";
tb.Color = 'w';
tb.FontWeight = 'bold';
tb.LineStyle = 'none';
tb.FontSize = 20;
tbStartX = startX; %+ (barPixelLength/15);

[tb.Position(1), ~] = coord2norm(ca, tbStartX, by);
tb.Position(2) = 0.02;
%[tb.Position(3), tb.Position(3)] = coord2norm(ca, 50, 20);
