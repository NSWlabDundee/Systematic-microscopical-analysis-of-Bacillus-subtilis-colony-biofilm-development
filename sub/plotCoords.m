function plotCoords(normaliseXY)
%Set normaliseY to 1 or 0

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
figure;
mutants = ["WT", "tapA", "sipW", "tasA", "tapAtasA", "epsH", "bslA"]; % mutant names based on how the mat files are named
Tmax = 10; % max no of time points

for mm = 1:length(mutants) % loop through each mat file
   subplot(2,4,mm) %new subplot + some plot house keeping
   grid on
   hold on
   
   
   dataIn = load(mutants(mm)+ "_movements"); % load the data
   data = dataIn.(strcat(mutants(mm)+"coords")); % store the coords variable
   %figure; hold on
   for thisImage = 1:6
       [numROIs, numT, ~] = size(data{thisImage});
       
       if normaliseXY == 1
           for thisROI = 1:numROIs
               data{thisImage}(thisROI, :, 1) = data{thisImage}(thisROI, :, 1) - data{thisImage}(thisROI, 1, 1);
               data{thisImage}(thisROI, :, 2) = data{thisImage}(thisROI, :, 2) - data{thisImage}(thisROI, 1, 2);
           end
       end
       
       plot(data{thisImage}(:,1:Tmax,1)', data{thisImage}(:,1:Tmax,2)', '-o', 'color', 'k')
       xlim([0 1024]);
       ylim([0 1024]);
       title(["\it"+{mutants(mm)}]);
   end
end


