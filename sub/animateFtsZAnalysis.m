function animateFtsZAnalysis(session, imageId, tpoints, renderScale)

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

f = figure;
hold on;
frames(64) = struct('cdata',[],'colormap',[]);
frameCounter = 1;

img = squeeze(getMovie(session, imageId, 1, tpoints));
rois = getROIsFromImageId(imageId);
theImage = getImages(session, imageId);
pixels = theImage.getPrimaryPixels;
physX = pixels.getPhysicalSizeX.getValue;

[sizeX, sizeY, ~] = size(img);


for thisT = 1:19
    imshow(img(:,:,thisT), renderScale);
    axis tight;
    hold on;
    ca = f.CurrentAxes;
    
    if find(tpoints==thisT)
        roiIdx = [];
        for thisROI = 1:15
            roiT = rois{thisROI}.shape1.getTheT.getValue;
            if thisT == roiT
                roiIdx = [roiIdx, roiT];
            end
        end
        
        numToDraw = numel(roiIdx);
        for thisDraw = 1:numToDraw
            x = rois{thisROI}.shape1.getX.getValue;
            y = rois{thisROI}.shape1.getY.getValue;
            roiId = rois{thisROI}.shape1.getTextValue.getValue;
            
            [normX, normY] = coord2norm(ca, x, sizeY-y);
            
            points{thisDraw} = annotation('ellipse', [normX, normY, 0.02, 0.02], 'color', 'g');
        end
        
        for thisFrame = 1:5
            frames(frameCounter) = getframe(gcf);
            pause(0.5);
            frameCounter = frameCounter + 1;
        end
        
        %Delete the points for the next time-point
        for thisPoint = 1:numel(points)
            point = points{thisPoint};
            point.delete;
        end
    else
        frames(frameCounter) = getframe(gcf);
        pause(0.5);
        frameCounter = frameCounter + 1;
    end
    
end

saveFramesAsAVI(frames, 2, 'ftsZ');
    