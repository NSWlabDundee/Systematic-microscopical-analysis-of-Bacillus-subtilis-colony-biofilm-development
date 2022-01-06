function animatePlot(img, renderScale, ROIcoords1, ROIcoords2, rightMost, xScale, yScale)

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

[numData, ~] = size(ROIcoords1);
frames(numData+2) = struct('cdata',[],'colormap',[]);

%plot the two tracks over the image data
for thisDatum = 1:numData-3
    imshow(img(:,:,thisDatum), renderScale); hold on;
    plot(ROIcoords1(1:thisDatum+1, 1), ROIcoords1(1:thisDatum+1, 2), 'm-o');
    plot(ROIcoords2(1:thisDatum+1, 1), ROIcoords2(1:thisDatum+1, 2), 'g-o');
    plot([rightMost(thisDatum) rightMost(thisDatum)], [0 1024], 'c')
    xlim(xScale);
    ylim(yScale);
    ax = gca;
    ax.XAxis.Visible = 'on';
    ax.XLabel.String = 'Pixel Position';
    ax.YAxis.Visible = 'on';
    ax.YLabel.String = 'Pixel Position';
    
    ca = f.CurrentAxes;
    
    [stepNormX1, stepNormY1] = coord2norm(ca, ROIcoords1(thisDatum, 1), 1024-ROIcoords1(thisDatum, 2)-20);
    [stepNormX2, stepNormY2] = coord2norm(ca, ROIcoords1(thisDatum+1, 1), 1024-ROIcoords1(thisDatum+1, 2)-20);
    [stepText1X, stepText1Y] = coord2norm(ca, ROIcoords1(thisDatum, 1)+((ROIcoords1(thisDatum+1, 1)-ROIcoords1(thisDatum, 1))/2)-15, 1024-ROIcoords1(thisDatum+1, 2)-140);
    stepArrow1 = annotation('doublearrow', [stepNormX1 stepNormX2], [stepNormY1 stepNormY2], 'color', 'y');
    stepText1 = annotation('textbox', [stepText1X, stepText1Y, 0.1, 0.1], 'color', 'y', 'String', 's', 'LineStyle', 'none');
    
    [distNormX1, distNormY1] = coord2norm(ca, ROIcoords1(thisDatum+1, 1), 1024-ROIcoords1(thisDatum+1, 2));
    [distNormX2, distNormY2] = coord2norm(ca, rightMost(thisDatum, 1), 1024-ROIcoords1(thisDatum+1, 2));
    [distText1X, distText1Y] = coord2norm(ca, ROIcoords1(thisDatum+1, 1)+((rightMost(thisDatum, 1)-ROIcoords1(thisDatum+1, 1))/2)-15, 1024-ROIcoords1(thisDatum+1, 2)-120);
    distArrow1 = annotation('doublearrow', [distNormX1 distNormX2], [distNormY1 distNormY2], 'color', 'y');
    distText1 = annotation('textbox', [distText1X, distText1Y, 0.1, 0.1], 'color', 'y', 'String', 'd', 'LineStyle', 'none');
    
    [stepNormX1, stepNormY1] = coord2norm(ca, ROIcoords2(thisDatum, 1), 1024-ROIcoords2(thisDatum, 2)-20);
    [stepNormX2, stepNormY2] = coord2norm(ca, ROIcoords2(thisDatum+1, 1), 1024-ROIcoords2(thisDatum+1, 2)-20);
    [stepText2X, stepText2Y] = coord2norm(ca, ROIcoords2(thisDatum, 1)+((ROIcoords2(thisDatum+1, 1)-ROIcoords2(thisDatum, 1))/2)-15, 1024-ROIcoords2(thisDatum+1, 2)-140);
    stepArrow2 = annotation('doublearrow', [stepNormX1 stepNormX2], [stepNormY1 stepNormY2], 'color', 'y');
    stepText2 = annotation('textbox', [stepText2X, stepText2Y, 0.1, 0.1], 'color', 'y', 'String', 's', 'LineStyle', 'none');
    
    [distNormX1, distNormY1] = coord2norm(ca, ROIcoords2(thisDatum+1, 1), 1024-ROIcoords2(thisDatum+1, 2));
    [distNormX2, distNormY2] = coord2norm(ca, rightMost(thisDatum, 1), 1024-ROIcoords2(thisDatum+1, 2));
    [distText2X, distText2Y] = coord2norm(ca, ROIcoords2(thisDatum+1, 1)+((rightMost(thisDatum, 1)-ROIcoords2(thisDatum+1, 1))/2)-15, 1024-ROIcoords2(thisDatum+1, 2)-120);
    distArrow2 = annotation('doublearrow', [distNormX1 distNormX2], [distNormY1 distNormY2], 'color', 'y');
    distText2 = annotation('textbox', [distText2X, distText2Y, 0.1, 0.1], 'color', 'y', 'String', 'd', 'LineStyle', 'none');
    
    
%     stepArrow.Parent = f.CurrentAxes;
%     stepArrow.X = [ROIcoords2(thisDatum, 1) ROIcoords2(thisDatum+1, 1)];
%     stepArrow.Y = [ROIcoords2(thisDatum, 2) ROIcoords2(thisDatum+1, 2)];
    
    frames(thisDatum) = getframe(gcf);
    pause(0.5)
    if thisDatum < numData-3
        stepArrow1.delete;
        stepText1.delete;
        distArrow1.delete;
        distText1.delete;
        stepArrow2.delete;
        stepText2.delete;
        distArrow2.delete;
        distText2.delete;
    end
    
end

for thisFrame = 1:5
    frames(thisDatum+thisFrame) = getframe(gcf);
end

v = VideoWriter('WT_landmarks_arrows.avi');
v.FrameRate = 2;

open(v);
writeVideo(v,frames);
close(v);