function [coords, distMat, steps] = trackPointROIDistances(session, imageId)
% [coords, distMat, steps] = trackPointROIDistances(session, imageId)
%The session object should be declared as global.

%Copyright (C) 2013-2022 University of Dundee & Open Microscopy Environment.
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
rois = getROIsFromImageId(imageId);
numROIs = length(rois);
%[sizeX, sizeY, ~] = size(volumeImage);
% figure;
% hold on;
coords = [];
steps = [];

%For each point ROI extract the coords and calculate the distance matrix
%and step-size per timepoint. Use pixels size to convert step-size to um.
figure;
xlim([0 1024]);
ylim([0 1024]);
hold on;
for thisROI = 1:numROIs
    roi = rois{thisROI};
    if ~(roi.shapeType == 'point')
        continue;
    end
    numShapes = rois{thisROI}.numShapes;
    %Sort ROIshapes by time and get their coords
    for thisShape = 1:rois{thisROI}.numShapes
        ts(thisShape) = rois{thisROI}.(['shape' num2str(thisShape)]).getTheT.getValue;
        [~, idx] = sort(ts);
        counter = 1;
    end
    ts = [];
    for thisShape = idx
        coords(thisROI, counter, 1) = roi.(['shape' num2str(thisShape)]).getX.getValue;
        coords(thisROI, counter, 2) = roi.(['shape' num2str(thisShape)]).getY.getValue;
        counter = counter + 1;
    end
    
    
%     for thisShape = 1:numShapes
%         coords(thisROI, thisShape, 1) = roi.(['shape' num2str(thisShape)]).getX.getValue;
%         coords(thisROI, thisShape, 2) = roi.(['shape' num2str(thisShape)]).getY.getValue;
%     end
    distMat{thisROI} = squareform(pdist(squeeze(coords(thisROI,:,:))));
    for thisx = 2:numShapes
        steps(thisROI, thisx-1) = distMat{thisROI}(thisx, thisx-1);
    end
    steps = steps.*physX;
    plot(coords(thisROI, :, 1), coords(thisROI, :, 2), '-o');
end
