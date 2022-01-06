function animateTracksOnMovie(img, renderScale, data1, data2, rightMost, xScale, yScale)

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
axis tight;

[numData, ~] = size(data1);
frames(numData-1) = struct('cdata',[],'colormap',[]);

%plot the two tracks over the image data
for thisDatum = 1:numData-1
    imshow(img(:,:,thisDatum), renderScale); hold on;
    xData1 = data1(1:thisDatum+1, 1);
    yData1 = data1(1:thisDatum+1, 2);
    xData2 = data2(1:thisDatum+1, 1);
    yData2 = data2(1:thisDatum+1, 2);
    plot(xData1, yData1, 'm-o');
    plot(xData2, yData2, 'y-o');
    plot([rightMost(thisDatum) rightMost(thisDatum)], [0 1024], 'c')
    xlim(xScale);
    ylim(yScale);
    ax = gca;
    ax.XAxis.Visible = true;
    ax.XLabel.String = 'Pixel Position';
    ax.XLabel.FontSize = 16;
    ax.YAxis.Visible = true;
    ax.YLabel.String = 'Pixel Position';
    ax.YLabel.FontSize = 16;
    ax.YDir = 'normal';
    
    %Add measurement annotations
    ca = f.CurrentAxes;
    [normXedge, ~] = coord2norm(ca, rightMost(thisDatum), rightMost(thisDatum));
    
    [normXstart, normYstart] = coord2norm(ca, xData1(end)+5, yData1(end));
    [xDBox, yDBox] = coord2norm(ca,  rightMost(thisDatum) - ((rightMost(thisDatum) - xData1(end))/2)-10, yData1(end)-5);
    arrows{1} = annotation('doublearrow', [normXstart, normXedge], [normYstart, normYstart], 'color', 'g');
    text{1} = annotation('textbox', [xDBox, yDBox, 0.01, 0.01], 'color', 'g', 'String', 'd', 'LineStyle', 'none', 'FontSize', 14);
    
    [normXstart, normYstart] = coord2norm(ca, xData2(end)+5, yData2(end));
    [xDBox, yDBox] = coord2norm(ca,  rightMost(thisDatum) - ((rightMost(thisDatum) - xData2(end))/2)-10, yData2(end)-5);
    arrows{2} = annotation('doublearrow', [normXstart, normXedge], [normYstart, normYstart], 'color', 'g');
    text{2} = annotation('textbox', [xDBox, yDBox, 0.01, 0.01], 'color', 'g', 'String', 'd', 'LineStyle', 'none', 'FontSize', 14);
    
    
    [normXstart, normYstart] = coord2norm(ca, xData1(end-1), yData1(end-1)-10);
    [normXend, normYend] = coord2norm(ca, xData1(end), yData1(end)-10);
    [xDBox, yDBox] = coord2norm(ca,  xData1(end) - ((xData1(end) - xData1(end-1))/2)-12, yData1(end)-15);
    arrows{3} = annotation('doublearrow', [normXstart, normXend], [normYstart, normYend], 'color', 'g');
    text{3} = annotation('textbox', [xDBox, yDBox, 0.01, 0.01], 'color', 'g', 'String', 's', 'LineStyle', 'none', 'FontSize', 14);
    
    [normXstart, normYstart] = coord2norm(ca, xData2(end-1), yData2(end-1)-10);
    [normXend, normYend] = coord2norm(ca, xData2(end), yData2(end)-10);
    [xDBox, yDBox] = coord2norm(ca,  xData2(end) - ((xData2(end) - xData2(end-1))/2)-5, yData2(end)-20);
    arrows{4} = annotation('doublearrow', [normXstart, normXend], [normYstart, normYend], 'color', 'g');
    text{4} = annotation('textbox', [xDBox, yDBox, 0.01, 0.01], 'color', 'g', 'String', 's', 'LineStyle', 'none', 'FontSize', 14);
    
    
    frames(thisDatum) = getframe(gcf);
    
    %pause(0.1)
    
    for thisAnn = 1:4
        arrows{thisAnn}.delete;
        text{thisAnn}.delete;
    end
    
end



saveFramesAsAVI(frames, 2, 'tracks_overlaid');

