function output = biofilmAreaFromReflectedLight(session, dsIds, c, thresh)
%Pass in a datasetId and reflected light channel number (index from 0) to
%return the areas of the biofilms. Minimum size of biofilm is hard coded to
%filter out noise from the agar. Set thresh to 900 for WT 24h, otherwise 0.

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

[sortedImages imageIds imageNames sortedDatasetNames] = getImageIdsAndNamesFromDatasetIds(dsIds);

numImages = numel(imageIds);
output = {};

for thisImage = 1:numImages
    disp(num2str(thisImage))
    %Get the pixel dimentions of the image
    img = getImages(session, imageIds(thisImage));
    pixels = img.getPrimaryPixels;
    physX = pixels.getPhysicalSizeX.getValue;
    physY = pixels.getPhysicalSizeY.getValue;
    pxArea = physX*physY;
    
    %Segment the image
    rl = getPlane(session, imageIds(thisImage), 0, c, 0);
    rlSeg = seg2DThresh(double(rl), 0, 0, thresh, 1000, 'a');
%     rlSegFill = imfill(logical(rlSeg), 'holes');
    props = regionprops(logical(rlSeg), 'ConvexArea');
    
    %Calculate the biofilm area
    biofilmArea = pxArea*max([props.ConvexArea]');
    
    %Format output
    output{thisImage, 1} = imageIds(thisImage);
    output{thisImage, 2} = imageNames{thisImage};
    output{thisImage, 3} = biofilmArea;
end