% import_nightly_viirs.m

% clear; close all

% 'Import' single daily VIIRS file into Matlab

% Subset the data
lat = -65:0.0041666:75;
lon = -180:0.00416666:180;

ilon = find(lon <= -125 | lon > -116.45);
lon(ilon) = [];
SVDNB_npp_d20240815_rade9d(:,ilon) = [];

ilat = find(lat <= 45.5 | lat > 50);
lat(ilat) = [];
SVDNB_npp_d20240815_rade9d = flipud(SVDNB_npp_d20240815_rade9d);
SVDNB_npp_d20240815_rade9d(ilat,:) = [];

rad = double(SVDNB_npp_d20240815_rade9d); 

%% Save data
% save('viirs_rad_081524d_subset.mat')
