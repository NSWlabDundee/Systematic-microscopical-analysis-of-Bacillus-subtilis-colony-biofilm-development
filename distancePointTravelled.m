function distanceTravelled = distancePointTravelled(distMat)

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

numImages = length(distMat);
for thisImage = 1:numImages
    numROIs = length(distMat{thisImage});
    for thisROI = 1:numROIs
        numT = size(distMat{thisImage}{thisROI}(:,1));
        pointDist = [];
        for thisT = 2:numT
            pointDist(thisT-1) = distMat{thisImage}{thisROI}(thisT, thisT-1);
        end
        distanceTravelled(thisImage, thisROI) = sum(pointDist);
    end
end
