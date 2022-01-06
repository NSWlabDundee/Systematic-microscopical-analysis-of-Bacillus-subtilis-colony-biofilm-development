function plotDistFromFront(normaliseY)

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

%Set normaliseY to 1 or 0
figure;
mutants = ["WT", "tapA", "sipW", "tasA", "tapAtasA", "epsH", "bslA"]; % mutant names based on how the mat files are name
%colour = ["c", "m", "y", "k", "b", "r"];
colour = ["k", "k", "k", "k", "k", "k"];
Tmax = 10; % max no of time points
xvals = (1:10)';
for mm = 1:length(mutants) % loop through each mat file
%     figure;
       subplot(2,4,mm) %new subplot + some plot house keeping
       grid on
       hold on
    
    data = load(mutants(mm)+ "_steps_vs_dist"); % load the data
    distFromFront = data.(strcat(mutants(mm)+"distFromFront")); % store the coords variable
    
    %figure; hold on
    for thisImage = 1:6
        
        %        for thisROI = 1:6
        %            distFromFront{thisImage}(thisROI, :) = distFromFront{thisImage}(thisROI, :) - distFromFront{thisImage}(thisROI, 1);
        %        end
        if normaliseY
            for thisROI = 1:6
                distFromFront{thisImage}(:, 1:Tmax) = distFromFront{thisImage}(:, 1:Tmax) - distFromFront{thisImage}(:, 1);
            end
            ylabel('Change in Distance to Front (\mum)')
            ylim([-250 250]);
            xlim([1 10]);
        else
            ylabel('Distance to Front (\mum)')
            ylim([0 500]);
            xlim([1 10]);
        end
        
        plot(xvals, distFromFront{thisImage}(:, 1:Tmax)', '-o', 'color', colour(thisImage))
        title({"\it"+mutants(mm)})
        xlabel('Time-point')
        
    end
    %    ylim([0 500]);
    %    title({"\it"+mutants(mm)})
    %    xlabel('Time-point')
    %    ylabel('Distance to Front (\mum)')
end




%    dataIn = load(mutants(mm)+ "_movements"); % load the data
%    data = dataIn.(strcat(mutants(mm)+"coords")); % store the coords variable


%        if normaliseXY == 1
%            for thisROI = 1:numROIs
%                data{thisImage}(thisROI, :, 1) = data{thisImage}(thisROI, :, 1) - data{thisImage}(thisROI, 1, 1);
%                data{thisImage}(thisROI, :, 2) = data{thisImage}(thisROI, :, 2) - data{thisImage}(thisROI, 1, 2);
%            end
%        end
%
