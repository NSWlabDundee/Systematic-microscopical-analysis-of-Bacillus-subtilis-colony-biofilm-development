function distFromFront = distanceFromBiofilmFront(session, imageId, rightMost, pointCoords)
% [distFromFront, stats, gof] = distanceFromBiofilmFront(session, imageId, rightMost, pointCoords)

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

%Collect image metadata and ROIs
imageObj = getImages(session, imageId);
pixels = imageObj.getPrimaryPixels;
physX = pixels.getPhysicalSizeX.getValue;
[numROI, ~] = size(pointCoords);
%checkT(1) = length(rightMost);
[~, numTcoords, ~] = size(pointCoords);
numTright = length(rightMost);
%numT = min([numTcoords, numTright]);
numT = 10;

% % %This is the bit swapped out for the multi-commented section below:
% % for thisROI = 1:numROI
% %     for thisT = 1:numT
% %         distFromFront(thisROI, thisT) = rightMost(thisT) - pointCoords(thisROI, thisT) * physX;
% %     end
% % end

%Fit the right-most pixel data to a line, check for outliers and re-fit.
%This is the same as the expansion rate analysis.
%rightMost = rightMost';
xdata = [1:length(rightMost)]';
[testFit, gof] = fit(xdata, rightMost, 'power2');

fdata = feval(testFit,xdata); 
I = abs(fdata - rightMost) > 1.5*std(rightMost); 
outliers = excludedata(xdata,rightMost,'indices',I);

[expansionFit , gof] = fit(xdata, rightMost, 'power2', 'Exclude',outliers);

%Evaluate the fit (right-most coord) at each time-point and get the
%distance to each ROI

for thisROI = 1:numROI
    for thisT = 1:numT
        expansionX = round(feval(expansionFit, thisT));
        distFromFront(thisROI, thisT) = expansionX - pointCoords(thisROI, thisT) * physX;
    end
end

% %Use right-most pixel position from segmented image to calculate distance,
% %in um, for each point at each time point. Fit a linear function to each
% %ROI
% for thisROI = 1:numROI
%     for thisT = 1:numT
%         distFromFront(thisROI, thisT) = rightMost(thisT) - pointCoords(thisROI, thisT) * physX;
%     end
%     distToFit = distFromFront(thisROI, :)';
%     xdata = 1:numT;
%     if isnan(distToFit)
%         stats{thisROI} = [];
%         gof{thisROI} = [];
%     else
%         distNans = isnan(distToFit);
%         if find(distNans)
%             maxIdx = find(distNans, 1, 'first')-1;
%             xdata = 1:maxIdx;
%             distToFit = distFromFront(thisROI, 1:maxIdx)';
%         end
%         [stats{thisROI}, gof{thisROI}] = fit(xdata', distToFit, 'poly1');
%     end
% end
