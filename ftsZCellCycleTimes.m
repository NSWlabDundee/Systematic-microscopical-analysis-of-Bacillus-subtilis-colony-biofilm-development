function cycleTimes = ftsZCellCycleTimes(session, imageId)

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

rois = getROIsFromImageId(imageId);

ids = [];
parents = [];
tpoints = [];
cycleTimes = [];
nodes = 0;
numROIs = numel(rois);
if isempty(rois)
    return;
end

for thisROI = 1:numROIs
    ids(end+1) = rois{thisROI}.ROIId;
    parents(end+1) = str2num(rois{thisROI}.shape1.getTextValue.getValue);
    tpoints(end+1) = rois{thisROI}.shape1.getTheT.getValue;
end


for thisROI = 1:numROIs
    thisId = ids(thisROI);
    idx = find(parents==thisId);
    if isempty(idx)
        continue;
    end
    
    numIdx = numel(idx);
    parentT = tpoints(thisROI);
    for thisIdx = 1:numIdx
        childT = tpoints(idx(thisIdx));
        cycleTimes(end+1) = (childT - parentT) * 10;
        nodes = [nodes, find(ids==thisId)];
    end
end

%rootParents = find(