function saveMovieFromOMERO(session, imageId, z, c, tRange, startAge, interval, renderScale, scaleBarLength, frameRate, label, strainLabel)
%z index from 1. c index from 1. tRange as vector, index
%from 1. renderScale as [min, max]. fileName as string without .extension.
%frameRate as integer, suggest values from 2 to 4.

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

theImage = getImages(session, imageId);
pixels = theImage.getPrimaryPixels;
imageName = char(theImage.getName.getValue);
fileName = strrep(imageName, '/', '_');

%Create timestamp text
%numT = numel(tRange);
minuteInterval = minutes(interval);
timeArray = hours(0:minuteInterval:50) + startAge;
hoursArray = duration(hours(timeArray));

numT = numel(tRange);
f = figure;
hold on;
frames(numT) = struct('cdata',[],'colormap',[]);
frameCounter = 1;


for thisT = tRange
    disp([num2str(thisT) ' of ' num2str(tRange(end))]);
    img = getPlane(session, imageId, z-1, c-1, thisT-1);
    imshow(img, renderScale);
    axis tight;
    hold on;
    
    [scaleBar, scaleLabel] = makeScaleBar(pixels, scaleBarLength);
    timeStamp = makeTimeStamp(pixels, hoursArray, thisT);
    if label == 1
        labelText = makeStrainLabel(pixels, strainLabel);
    end
    
    frames(frameCounter) = getframe(gcf);
    pause(0.1)
    scaleBar.delete;
    scaleLabel.delete;
    timeStamp.delete;
    if label == 1
        labelText.delete;
    end
    frameCounter = frameCounter + 1;
end

f.delete;
saveFramesAsAVI(frames, frameRate, fileName);