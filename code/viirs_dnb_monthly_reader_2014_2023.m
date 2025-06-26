% viirs_dnb_monthly_reader_2014_2023.m

% Loads and maps monthly composites of day/night band from VIIRS from 2014-2023.
% The stray light version was not available for 2012-2013, 
% so there is no data coverage for the months of interest for this period.

% April 5, 2024

clear
close all

%% Load Data and Create Subsetted Matlab file for Analysis
path = '/Users/jschulien/MATLAB/ALAN/data/VIIRS/VIIRS_2014_2023'; 
cd(path); 

tic
D = dir; 
for k = 4:length(D) 
    currD = D(k).name; 
    cd(fullfile(path, currD)) 

%     % Load pixel coverage files
    fname = [currD '.cf_cvg.tif'];
    t = Tiff(fname,'r');
    imageData = read(t);
    cf_cvg = double(imageData); clear imageData t fname

    % Load radiance file
    fname = [currD '.avg_rade9h.tif'];
    t = Tiff(fname,'r');
    imageData = read(t);
    rad = double(imageData); % clear imageData 
    % imshow(imageData); return

    % Subset the data
    lat = 0:0.00416667:75;
    lon = -180:0.00416667:-60;

    ilon = find(lon <= -125 | lon > -116.45); % Final full area saved
    lon(ilon) = []; 
    rad(:,ilon) = [];
    cf_cvg(:,ilon) = []; clear ilon

    ilat = find(lat <= 45.5 | lat > 50);
    lat(ilat) = []; 
    rad = flipud(rad);
    rad(ilat,:) = [];
    cf_cvg = flipud(cf_cvg);
    cf_cvg(ilat,:) = []; clear ilat

    lat_cell{k} = lat; clear lat
    lon_cell{k} = lon; clear lon
    rad_cell{k} = rad; clear rad
    cf_cvg_cell{k} = cf_cvg; clear cf_cvg
    k
end
clear k
toc % (3629.856472 seconds)

lat_cell = lat_cell(4:end);
lon_cell = lon_cell(4:end);
rad_cell = rad_cell(4:end);
cf_cvg_cell = cf_cvg_cell(4:end);

% Save 
save('viirs_subset_2014_2023_sl.mat') % Does not include 2022/08 as these data are formatted differently (different sensor)
