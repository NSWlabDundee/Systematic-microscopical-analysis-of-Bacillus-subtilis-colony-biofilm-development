function timeStamp = makeTimeStamp(pixels, hoursArray, thisT)
%Make a timeStamp text annotation to place on movies

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
startX = sizeX - 120; 


f = gcf;
ca = f.CurrentAxes;


[h, m, s] = hms(hoursArray(thisT));
if int8(s) == 60
    m = m + 1;
end
timeText = [num2str(h), 'h:', num2str(m) 'm'];

timeStamp = annotation('textbox');
timeStamp.String = timeText;
timeStamp.Color = 'w';
timeStamp.FontWeight = 'bold';
timeStamp.LineStyle = 'none';
timeStamp.FontSize = 20;

[timeStamp.Position(1), ~] = coord2norm(ca, startX, 0);
timeStamp.Position(2) = 0.045;