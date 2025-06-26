% match_nightly_viirs.m
% Creates panels b and c for Figure 4

clear; close all

addpath('/Users/jschulien/m_map')
wvl = [380, 395, 412, 443, 465, 490, 510, 532, 555, 560, 565, 589, 625, 665, 670, 683, 694, 710, 800]; % in-situ wavelengths (800 = PAR)

%% Import C-OPS and VIIRS/DNB response curves 
path = '/Users/jschulien/MATLAB/ALAN/data/ResponseCurves'; cd(path);
fname = 'SpectralResponse_Ed0 SN851.csv';
dat = dlmread(fname, ',', 1, 0);
response_in_situ = dat(:,2:end); % not inlcuding PAR
wavelength_in_situ = dat(:,1); clear dat path fname

fname = 'suomi_NPP_onorbit_datathief.csv';
dat = dlmread(fname, ',', 1, 0); 
% figure; plot(dat(:,1),dat(:,2),'k.','MarkerSize',14); grid on
dat = sortrows(dat); 
wavelength_viirs = dat(:,1); viirs_response = dat(:,2); clear dat fname

%% Import Data 08/05/24 [VIIRS 08/06/24]
% Import daily VIIRS/DNB image 
path = '/Users/jschulien/MATLAB/ALAN/data/VIIRS/Nightly/080624'; cd(path); 
fname = 'viirs_rad_080624d_subset.mat'; % from import_nightly_viirs.m
load(fname); clear fname
[long,latg] = meshgrid(lon, lat);

% Load C-OPS data
path = '/Users/jschulien/Matlab/ALAN/data/COPS/080524_night'; cd(path); 
load('COPS_night_irr_080524.mat'); 

% Identify Lake Washington data
path = ('/Users/jschulien/Matlab/Waterbodies_with_History_and_Jurisdictional_detail___wtrbdy_det_area'); cd(path)
S = shaperead('Waterbodies_with_History_and_Jurisdictional_detail___wtrbdy_det_area.shp');

F = S(16284); % Lake Washington
lonshp = F.X; latshp = F.Y;

in = inpolygon(long + km2deg(0.25),latg - km2deg(0.25),lonshp,latshp); % Identifying bin centers within lake boundary

latt = latg; lont = long; radg = rad; % Creates new variables with gridded structure for mapping
latg(~in) = NaN; long(~in) = NaN; rad(~in) = NaN; % Creates vector with only data within Lake Washington
idx = find(isnan(latg)); latg(idx) = []; long(idx) = []; rad(idx) = []; 

nlong = long + km2deg(0.25); nlatg = latg - km2deg(0.25); % Define bin centers

% Verify bin centers
% figure; plot(lonshp,latshp,'k-','LineWidth',2); hold on
% plot(long,latg,'b.','MarkerSize',11);
% plot(nlong,nlatg,'r.','MarkerSize',11); % Bin centers
% return

% Import nighttime C-OPS Ed0 data
cast = [1:32]; idx_dark = [1,12,22,32]; % 8/5/24 Logsheet data

% 8/5/24 in-situ sites
lon = [-122.210429000000	-122.218894000000	-122.227290000000	-122.235547000000	-122.227124000000	-122.222820000000	-122.218930000000	-122.227075000000	-122.214662000000	-122.210691000000	-122.206665000000	-122.210589000000	-122.214793000000	-122.235455000000	-122.243948000000	-122.235746000000	-122.243968000000	-122.248096000000	-122.260397000000	-122.268594000000	-122.256166000000	-122.260585000000	-122.260500000000	-122.264922000000	-122.252150000000	-122.252237000000	-122.227409000000	-122.227240000000];
lat = [47.5058330000000	47.5059820000000	47.5058580000000	47.5100810000000	47.5141580000000	47.5141980000000	47.5142010000000	47.5184590000000	47.5224530000000	47.5224420000000	47.5266130000000	47.5308400000000	47.5266630000000	47.5184290000000	47.5267850000000	47.5640320000000	47.5642100000000	47.5685450000000	47.5724540000000	47.5766200000000	47.5766650000000	47.5891020000000	47.6017130000000	47.6017110000000	47.6142900000000	47.6267240000000	47.6644510000000	47.6724200000000]; 

% Multiply spectral C-OPS data to match VIIRS/DNB spectral response
integrated_responses = zeros(1, 18); % 18 channels excluding PAR

% Loop over each in-situ channel to calculate the weighted response
for i = 1:18
    % Interpolate the in-situ response to match the VIIRS/DNB wavelength range
    in_situ_response_interp = interp1(wavelength_in_situ, response_in_situ(:, i), wavelength_viirs, 'linear', 'extrap');
    
    % Weight the in-situ response by the VIIRS/DNB response
    weighted_response = in_situ_response_interp .* viirs_response;
    
    % Integrate the weighted response over the VIIRS/DNB wavelength range
    integrated_responses(i) = trapz(wavelength_viirs, weighted_response);
end

% Combine the integrated responses to get a single value
% Multiply integrated_responses for each channel by each C-OPS channel 
Xmat_norm = mout(:,2:19) .* integrated_responses; % 18 wavelengths
Xvec_norm = sum(Xmat_norm,2);  

% Extract VIIRS/DNB data at L. Washington waypoints
for j = 1:size(lat,2) % for every C-OPS site        
    d = ((lon(j)-(nlong)).^2) + ((lat(j)-(nlatg)).^2);
    d = sqrt(d);
    d_min = min(min(d));
    ii = find(d == d_min);
    mat_out(j,1) = long(ii);
    mat_out(j,2) = latg(ii);
    mat_out(j,3) = lon(j);
    mat_out(j,4) = lat(j);
    mat_out(j,5) = deg2km(d_min);
    mat_out(j,6) = rad(ii); 
    clear d x y d_min
end
headers_mat_out = {'Lon-VIIRS','Lat-VIIRS','Lon-C-OPS','Lat-C-OPS','Delta-km','L-VIIRS'};
clear j ii

% Middle pelagic north 
roi2_lat = [47.69 47.69 47.66 47.657 47.648 47.649 47.66 47.6735 47.685 47.69];
roi2_lon = [-122.245 -122.225 -122.225 -122.241 -122.248 -122.26 -122.255 -122.236 -122.239 -122.245];
in2 = inpolygon(lon,lat,roi2_lon,roi2_lat);

% South suspension bridge 
roi4_lat = [47.5879 47.5879 47.592 47.592 47.5879];
roi4_lon = [-122.26 -122.278 -122.278 -122.26 -122.26]; 
in4 = inpolygon(lon,lat,roi4_lon,roi4_lat);

% Middle pelagic 3/south 
roi10_lat = [47.58075 47.58075 47.566 47.555 47.541 47.541 47.555 47.568 47.568 47.58075];
roi10_lon = [-122.278 -122.26 -122.2375 -122.2375 -122.25 -122.254 -122.24 -122.25 -122.262 -122.278]; 
in10 = inpolygon(lon,lat,roi10_lon,roi10_lat); 

% Southwest pelagic 
roi5_lat = [47.5349 47.535 47.52 47.515 47.51 47.516 47.52 47.5349];
roi5_lon = [-122.2565 -122.2515 -122.2315 -122.2165 -122.2165 -122.2365 -122.2465 -122.2565];
in5 = inpolygon(lon,lat,roi5_lon,roi5_lat);

% Middle pelagic 2/middle 
roi6_lat = [47.63 47.63 47.608 47.608 47.6 47.6 47.6 47.63];
roi6_lon = [-122.268 -122.25 -122.25 -122.23 -122.23 -122.25 -122.268 -122.268];
in6 = inpolygon(lon,lat,roi6_lon,roi6_lat);

% Southeast pelagic 
roi11_lat = [47.52 47.538 47.56 47.56 47.538 47.525 47.52];
roi11_lon = [-122.2165 -122.203 -122.203 -122.205 -122.205 -122.22 -122.2165];
in11 = inpolygon(lon,lat,roi11_lon,roi11_lat);

% Nearshore southsouthwest 
roi17_lat = [47.503 47.5125 47.514 47.521 47.521 47.512 47.509 47.498 47.503];
roi17_lon = [-122.22 -122.238 -122.25 -122.258 -122.265 -122.25 -122.238 -122.22 -122.22];
in17 = inpolygon(lon,lat,roi17_lon,roi17_lat);

% Nearshore north of Gene Coulon Park 
roi32_lat = [47.519 47.519 47.5335 47.5335 47.519];
roi32_lon = [-122.2105 -122.213 -122.204 -122.199 -122.2105];
in32 = inpolygon(lon,lat,roi32_lon,roi32_lat);

ii = [1,2,16]; % Sites not in an ROI
plot(mat_out(in2,6),Xvec_norm(in2),'k.','MarkerSize',18); hold on; 
plot(mat_out(in4,6),Xvec_norm(in4),'k.','MarkerSize',18);
plot(mat_out(in5,6),Xvec_norm(in5),'k.','MarkerSize',18);
plot(mat_out(in6,6),Xvec_norm(in6),'k.','MarkerSize',18);
plot(mat_out(in10,6),Xvec_norm(in10),'k.','MarkerSize',18);
plot(mat_out(in11,6),Xvec_norm(in11),'k.','MarkerSize',18);
plot(mat_out(in17,6),Xvec_norm(in17),'k.','MarkerSize',18);
plot(mat_out(in32,6),Xvec_norm(in32),'k.','MarkerSize',18);
plot(mat_out(ii,6),Xvec_norm(ii),'k.','MarkerSize',18);
grid on

Xmat = mout(:,2:end); 
X1 = [mat_out(in2,6);mat_out(in4,6);mat_out(in5,6);mat_out(in6,6);mat_out(in10,6);mat_out(in11,6);mat_out(in17,6);mat_out(in32,6);mat_out(ii,6)];
Y1 = [Xvec_norm(in2);Xvec_norm(in4);Xvec_norm(in5);Xvec_norm(in6);Xvec_norm(in10);Xvec_norm(in11);Xvec_norm(in17);Xvec_norm(in32);Xvec_norm(ii)];
light1 = [Xmat(in2,12);Xmat(in4,12);Xmat(in5,12);Xmat(in6,12);Xmat(in10,12);Xmat(in11,12);Xmat(in17,12);Xmat(in32,12);Xmat(ii,12)];

%% Nighttime sampling 8/6/2024 (VIIRS 08/07/2024)
% Import daily VIIRS/DNB image 
path = '/Users/jschulien/MATLAB/ALAN/data/VIIRS/Nightly/080724'; cd(path); 
fname = 'viirs_rad_080724d_subset.mat';
load(fname); clear fname
[long,latg] = meshgrid(lon, lat);

% Load C-OPS data
path = '/Users/jschulien/Matlab/ALAN/data/COPS/080624_night'; cd(path); 
load('COPS_night_irr_080624.mat'); 

% Identify Lake Washington data
path = ('/Users/jschulien/Matlab/Waterbodies_with_History_and_Jurisdictional_detail___wtrbdy_det_area'); cd(path)
S = shaperead('Waterbodies_with_History_and_Jurisdictional_detail___wtrbdy_det_area.shp');

F = S(16284); % Lake Washington
lonshp = F.X; latshp = F.Y;

in = inpolygon(long + km2deg(0.25),latg - km2deg(0.25),lonshp,latshp); % Identifying bin centers within lake boundary

latt = latg; lont = long; radg = rad; % Creates new variables with gridded structure for mapping
latg(~in) = NaN; long(~in) = NaN; rad(~in) = NaN; % Creates vector with only data within Lake Washington
idx = find(isnan(latg)); latg(idx) = []; long(idx) = []; rad(idx) = []; 

nlong = long + km2deg(0.25); nlatg = latg - km2deg(0.25); % Define bin centers

% Import nighttime C-OPS Ed0 data
cast = [1:58]; idx_dark = [1,13,25,36,49,58]; idx_error = 40; % Data from log sheet

% 8/6/24 in-situ sites
lat = [47.5808370000000	47.5807720000000	47.5808070000000	47.5850540000000	47.5891210000000	47.5849830000000	47.5891620000000	47.5933280000000	47.5976620000000	47.5933270000000	47.5932690000000	47.5975250000000	47.6016400000000	47.6057670000000	47.6016390000000	47.6057800000000	47.6057830000000	47.6058000000000	47.6182350000000	47.6224090000000	47.6224400000000	47.6307690000000	47.6391050000000	47.6391760000000	47.6391340000000	47.6432170000000	47.6474530000000	47.6515540000000	47.6557250000000	47.6598330000000	47.6598960000000	47.6640940000000	47.6682040000000	47.6723620000000	47.6807170000000	47.6892100000000	47.6890910000000	47.6932400000000	47.6973510000000	47.7057310000000	47.7058470000000	47.7057390000000	47.7098040000000	47.7141030000000	47.7139920000000	47.7223170000000	47.7265730000000	47.7307950000000	47.7348030000000	47.7390870000000	47.6849210000000];
lon = [-122.281351000000	-122.268828000000	-122.260498000000	-122.264722000000	-122.268816000000	-122.273032000000	-122.277273000000	-122.285508000000	-122.285429000000	-122.272902000000	-122.260526000000	-122.218784000000	-122.223120000000	-122.223146000000	-122.239807000000	-122.248022000000	-122.260550000000	-122.264673000000	-122.252166000000	-122.252110000000	-122.264649000000	-122.264770000000	-122.260479000000	-122.256247000000	-122.252126000000	-122.252113000000	-122.264593000000	-122.264578000000	-122.256264000000	-122.248038000000	-122.231437000000	-122.227332000000	-122.248030000000	-122.227265000000	-122.227140000000	-122.227307000000	-122.243842000000	-122.252122000000	-122.268856000000	-122.273049000000	-122.268791000000	-122.260651000000	-122.264626000000	-122.268913000000	-122.273098000000	-122.277046000000	-122.272907000000	-122.273026000000	-122.281236000000	-122.276938000000	-122.239755000000]; 

% Multiply spectral C-OPS data to match VIIRS/DNB spectral response
integrated_responses = zeros(1, 18); % 18 channel excluding PAR

% Loop over each in-situ channel to calculate the weighted response
for i = 1:18
    % Interpolate the in-situ response to match the VIIRS/DNB wavelength range
    in_situ_response_interp = interp1(wavelength_in_situ, response_in_situ(:, i), wavelength_viirs, 'linear', 'extrap');
    
    % Weight the in-situ response by the VIIRS/DNB response
    weighted_response = in_situ_response_interp .* viirs_response;
    
    % Integrate the weighted response over the VIIRS/DNB wavelength range
    integrated_responses(i) = trapz(wavelength_viirs, weighted_response);
end

% Combine the integrated responses to get a single value
% Multiply integrated_responses for each channel by each C-OPS channel 
Xmat_norm = mout(:,2:19) .* integrated_responses;
Xvec_norm = sum(Xmat_norm,2);  

% Extract VIIRS/DNB data at L. Washington waypoints
for j = 1:size(lat,2) % for every C-OPS site        
    d = ((lon(j)-(nlong)).^2) + ((lat(j)-(nlatg)).^2);
    d = sqrt(d);
    d_min = min(min(d));
    ii = find(d == d_min);
    mat_out(j,1) = long(ii);
    mat_out(j,2) = latg(ii);
    mat_out(j,3) = lon(j);
    mat_out(j,4) = lat(j);
    mat_out(j,5) = deg2km(d_min);
    mat_out(j,6) = rad(ii); 
    clear d x y d_min
end
clear j ii

% Northern pelagic
roi1_lon = [-122.275 -122.27 -122.27 -122.26 -122.25 -122.25 -122.25 -122.26 -122.265 -122.27 -122.275]; roi1_lon = roi1_lon - 0.0025;
roi1_lat = [47.74 47.74 47.73 47.71 47.7 47.695 47.695 47.695 47.71 47.72 47.74];
in1 = inpolygon(lon,lat,roi1_lon,roi1_lat);

% Middle pelagic north 
roi2_lat = [47.69 47.69 47.66 47.657 47.648 47.649 47.66 47.6735 47.685 47.69];
roi2_lon = [-122.245 -122.225 -122.225 -122.241 -122.248 -122.26 -122.255 -122.236 -122.239 -122.245];
in2 = inpolygon(lon,lat,roi2_lon,roi2_lat);

% North suspension bridge
roi3_lat = [47.643 47.641 47.638 47.64 47.643];
roi3_lon = [-122.269 -122.25 -122.25 -122.269 -122.269];
in3 = inpolygon(lon,lat,roi3_lon,roi3_lat);

% South suspension bridge 
roi4_lat = [47.5879 47.5879 47.592 47.592 47.5879];
roi4_lon = [-122.26 -122.278 -122.278 -122.26 -122.26]; 
in4 = inpolygon(lon,lat,roi4_lon,roi4_lat);

% Middle pelagic 2/middle 
roi6_lat = [47.63 47.63 47.608 47.608 47.6 47.6 47.6 47.63];
roi6_lon = [-122.268 -122.25 -122.25 -122.23 -122.23 -122.25 -122.268 -122.268];; 
in6 = inpolygon(lon,lat,roi6_lon,roi6_lat);

% Nearshore southcentral west 
roi19_lat = [47.55 47.585 47.585 47.558 47.55];
roi19_lon = [-122.259 -122.295 -122.285 -122.259 -122.259];
in19 = inpolygon(lon,lat,roi19_lon,roi19_lat);

% Nearshore central west 
roi20_lat = [47.592 47.592 47.619 47.619 47.592];
roi20_lon = [-122.285 -122.29 -122.282 -122.279 -122.285];
in20 = inpolygon(lon,lat,roi20_lon,roi20_lat);

% Nearshore north west 
roi22_lat = [47.69 47.74 47.74 47.69 47.69];
roi22_lon = [-122.27 -122.29 -122.282 -122.263 -122.27];
in22 = inpolygon(lon,lat,roi22_lon,roi22_lat);

ii = [2:4,6,10:14,22,26:28,33,38,41,51]; % Data not in an ROI
plot(mat_out(in1,6),Xvec_norm(in1),'ks','MarkerSize',8,'MarkerFaceColor','k'); hold on; 
plot(mat_out(in2,6),Xvec_norm(in2),'ks','MarkerSize',8,'MarkerFaceColor','k'); 
plot(mat_out(in3,6),Xvec_norm(in3),'ks','MarkerSize',8,'MarkerFaceColor','k');
plot(mat_out(in4,6),Xvec_norm(in4),'ks','MarkerSize',8,'MarkerFaceColor','k');
plot(mat_out(in6,6),Xvec_norm(in6),'ks','MarkerSize',8,'MarkerFaceColor','k');
plot(mat_out(in19,6),Xvec_norm(in19),'ks','MarkerSize',8,'MarkerFaceColor','k');
plot(mat_out(in20,6),Xvec_norm(in20),'ks','MarkerSize',8,'MarkerFaceColor','k');
plot(mat_out(in22,6),Xvec_norm(in22),'ks','MarkerSize',8,'MarkerFaceColor','k');
plot(mat_out(ii,6),Xvec_norm(ii),'ks','MarkerSize',8,'MarkerFaceColor','k');

Xmat = mout(:,2:end); 
X2 = [mat_out(in1,6);mat_out(in2,6);mat_out(in3,6);mat_out(in4,6);mat_out(in6,6);mat_out(in19,6);mat_out(in20,6);mat_out(in22,6);mat_out(ii,6)];
Y2 = [Xvec_norm(in1);Xvec_norm(in2);Xvec_norm(in3);Xvec_norm(in4);Xvec_norm(in6);Xvec_norm(in19);Xvec_norm(in20);Xvec_norm(in22);Xvec_norm(ii)]; 
light2 = [Xmat(in1,12);Xmat(in2,12);Xmat(in3,12);Xmat(in4,12);Xmat(in6,12);Xmat(in19,12);Xmat(in20,12);Xmat(in22,12);Xmat(ii,12)];

%% Nighttime sampling 8/7/2024 (VIIRS 08/08/2024)
% % Import average from C-OPS High Gains file
path = '/Users/jschulien/MATLAB/ALAN/data/COPS/080724_night/GAIN_files/High_gain'; cd(path);
load('080724_night_HIGH_dark.mat'); 

% Import daily VIIRS/DNB image 
path = '/Users/jschulien/MATLAB/ALAN/data/VIIRS/Nightly/080824'; cd(path); 
fname = 'viirs_rad_080824d_subset.mat';
load(fname); clear fname
[long,latg] = meshgrid(lon, lat);

% Load C-OPS data
path = '/Users/jschulien/Matlab/ALAN/data/COPS/080724_night'; cd(path); 
load('COPS_night_irr_080724.mat');

% Identify Lake Washington data
path = ('/Users/jschulien/Matlab/Waterbodies_with_History_and_Jurisdictional_detail___wtrbdy_det_area'); cd(path)
S = shaperead('Waterbodies_with_History_and_Jurisdictional_detail___wtrbdy_det_area.shp');

F = S(16284); % Lake Washington
lonshp = F.X; latshp = F.Y;

in = inpolygon(long + km2deg(0.25),latg - km2deg(0.25),lonshp,latshp); % Identifying bin centers within lake boundary

latt = latg; lont = long; radg = rad; % Creates new variables with gridded structure for mapping
latg(~in) = NaN; long(~in) = NaN; rad(~in) = NaN; % Creates vector with only data within Lake Washington
idx = find(isnan(latg)); latg(idx) = []; long(idx) = []; rad(idx) = []; 

nlong = long + km2deg(0.25); nlatg = latg - km2deg(0.25); % Define bin centers

% Import nighttime C-OPS Ed0 data
cast = [1:8]; idx_dark = 1; idx_error = [3,6]; % Data from log sheets

% 8/7/24 in-situ sites
lon = [-122.202318000000	-122.210826000000	-122.214029000000	-122.248041000000	-122.248183000000];
lat = [47.5057170000000	47.5020150000000	47.5019130000000	47.5266990000000	47.5435300000000];

% Multiply spectral C-OPS data to match VIIRS/DNB spectral response
integrated_responses = zeros(1, 18); % 18 channel excluding PAR

% Loop over each in-situ channel to calculate the weighted response
for i = 1:18
    % Interpolate the in-situ response to match the VIIRS/DNB wavelength range
    in_situ_response_interp = interp1(wavelength_in_situ, response_in_situ(:, i), wavelength_viirs, 'linear', 'extrap');
    
    % Weight the in-situ response by the VIIRS/DNB response
    weighted_response = in_situ_response_interp .* viirs_response;
    
    % Integrate the weighted response over the VIIRS/DNB wavelength range
    integrated_responses(i) = trapz(wavelength_viirs, weighted_response);
end

% Combine the integrated responses to get a single value
% Multiply integrated_responses for each channel by each C-OPS channel 
Xmat_norm = mout(:,2:19) .* integrated_responses;
Xvec_norm = sum(Xmat_norm,2);  

% Extract VIIRS/DNB data at L. Washington waypoints
for j = 1:size(lat,2) % for every C-OPS site        
    d = ((lon(j)-(nlong)).^2) + ((lat(j)-(nlatg)).^2);
    d = sqrt(d);
    d_min = min(min(d));
    ii = find(d == d_min);
    mat_out(j,1) = long(ii);
    mat_out(j,2) = latg(ii);
    mat_out(j,3) = lon(j);
    mat_out(j,4) = lat(j);
    mat_out(j,5) = deg2km(d_min);
    mat_out(j,6) = rad(ii); 
    clear d x y d_min
end
clear j ii

% Middle pelagic 3/south 
roi10_lat = [47.58075 47.58075 47.566 47.555 47.541 47.541 47.555 47.568 47.568 47.58075];
roi10_lon = [-122.278 -122.26 -122.2375 -122.2375 -122.25 -122.254 -122.24 -122.25 -122.262 -122.278];
in10 = inpolygon(lon,lat,roi10_lon,roi10_lat);

% Southwest pelagic 
roi5_lat = [47.5349 47.535 47.52 47.515 47.51 47.516 47.52 47.5349];
roi5_lon = [-122.2565 -122.2515 -122.2315 -122.2165 -122.2165 -122.2365 -122.2465 -122.2565];
in5 = inpolygon(lon,lat,roi5_lon,roi5_lat);

% Boeing-Renton (blue)
roi14_lat = [47.502 47.5045 47.5025 47.498 47.502];
roi14_lon = [-122.218 -122.206 -122.203 -122.218 -122.218];
in14 = inpolygon(lon,lat,roi14_lon,roi14_lat);

% Gene Coulon Park 
roi16_lat = [47.50425 47.513 47.5185 47.5185 47.512 47.50425 47.50425];
roi16_lon = [-122.2 -122.204 -122.2105 -122.213 -122.205 -122.204 -122.2];
in16 = inpolygon(lon,lat,roi16_lon,roi16_lat);

plot(mat_out(in5,6),Xvec_norm(in5),'k^','MarkerSize',8,'MarkerFaceColor','k'); hold on
plot(mat_out(in10,6),Xvec_norm(in10),'k^','MarkerSize',8,'MarkerFaceColor','k');
plot(mat_out(in14,6),Xvec_norm(in14),'k^','MarkerSize',8,'MarkerFaceColor','k');
plot(mat_out(in16,6),Xvec_norm(in16),'k^','MarkerSize',8,'MarkerFaceColor','k');
xlabel('L_V_I_I_R_S (nW cm^-^2 sr^-^1)'); ylabel('E_0 (\muW cm^-^2 nm^-^1)'); 
ax = gca; ax.GridColor = [0 0 0];  grid on;
set(gca,'FontSize',14); 

Xmat = mout(:,2:end); 
X3 = [mat_out(in5,6);mat_out(in10,6);mat_out(in14,6);mat_out(in16,6)];
Y3 = [Xvec_norm(in5);Xvec_norm(in10);Xvec_norm(in14);Xvec_norm(in16)]; 
light3 = [Xmat(in5,12);Xmat(in10,12);Xmat(in14,12);Xmat(in16,12)];

%% 8/14/2024 (VIIRS 08/15/2024)
% Import average from C-OPS High Gains file
path = '/Users/jschulien/MATLAB/ALAN/data/COPS/081424_night/GAIN_files/High_gain'; cd(path);
load('081424_night_HIGH_dark.mat'); 

% Import daily VIIRS/DNB image 
path = '/Users/jschulien/MATLAB/ALAN/data/VIIRS/Nightly/081524'; cd(path); 
fname = 'viirs_rad_081524d_subset.mat';
load(fname); clear fname
[long,latg] = meshgrid(lon, lat);

% Load C-OPS data
path = '/Users/jschulien/Matlab/ALAN/data/COPS/081424_night'; cd(path); 
load('COPS_night_irr_081424.mat');

% Identify Lake Washington data
path = ('/Users/jschulien/Matlab/Waterbodies_with_History_and_Jurisdictional_detail___wtrbdy_det_area'); cd(path)
S = shaperead('Waterbodies_with_History_and_Jurisdictional_detail___wtrbdy_det_area.shp');

% Define the bounding box coordinates for the Ship Canal
lat_min = 47.64; lat_max = 47.6656;
lon_min = -122.3975; lon_max = -122.2619;

% Create the region of interest
latshp = [lat_min, lat_max, lat_max, lat_min, lat_min];
lonshp = [lon_min, lon_min, lon_max, lon_max, lon_min];

in = inpolygon(long + km2deg(0.25),latg - km2deg(0.25),lonshp,latshp); % Identifying bin centers within lake boundary

latt = latg; lont = long; radg = rad; % Creates new variables with gridded structure for mapping
latg(~in) = NaN; long(~in) = NaN; rad(~in) = NaN; % Creates vector with only data within Lake Washington
idx = find(isnan(latg)); latg(idx) = []; long(idx) = []; rad(idx) = []; 

nlong = long + km2deg(0.25); nlatg = latg - km2deg(0.25); % Define bin centers

% Import nighttime C-OPS Ed0 data
cast = [1:25]; idx_dark = [1,15,25]; idx_error = [4,11,17]; % From log sheet

% 8/14/24 in-situ sites
lon = [-122.393718000000	-122.389501000000	-122.385610000000	-122.382714000000	-122.377043000000	-122.372996000000	-122.365723000000	-122.357932000000	-122.348068000000	-122.337285000000	-122.318778000000	-122.313947000000	-122.306243000000	-122.301919000000	-122.297949000000	-122.293818000000	-122.289656000000	-122.285195000000	-122.281345000000];
lat = [47.6641130000000	47.6640420000000	47.6640110000000	47.6619870000000	47.6599310000000	47.6598630000000	47.6550980000000	47.6511720000000	47.6473080000000	47.6434050000000	47.6515500000000	47.6487120000000	47.6473710000000	47.6474090000000	47.6473340000000	47.6474570000000	47.6474210000000	47.6474000000000	47.6474130000000];

% Multiply spectral C-OPS data to match VIIRS/DNB spectral response
% Initialize a variable to store the integrated responses for each in-situ channel
integrated_responses = zeros(1, 18); % 18 channel excluding PAR

% Loop over each in-situ channel to calculate the weighted response
for i = 1:18
    % Interpolate the in-situ response to match the VIIRS/DNB wavelength range
    in_situ_response_interp = interp1(wavelength_in_situ, response_in_situ(:, i), wavelength_viirs, 'linear', 'extrap');
    
    % Weight the in-situ response by the VIIRS/DNB response
    weighted_response = in_situ_response_interp .* viirs_response;
    
    % Integrate the weighted response over the VIIRS/DNB wavelength range
    integrated_responses(i) = trapz(wavelength_viirs, weighted_response);
end

% Combine the integrated responses to get a single value
% Multiply integrated_responses for each channel by each C-OPS channel 
Xmat_norm = mout(:,2:19) .* integrated_responses;
Xvec_norm = sum(Xmat_norm,2);  

% Extract VIIRS/DNB data at L. Washington waypoints
for j = 1:size(lat,2) % for every C-OPS site        
    d = ((lon(j)-(nlong)).^2) + ((lat(j)-(nlatg)).^2);
    d = sqrt(d);
    d_min = min(min(d));
    ii = find(d == d_min);
    mat_out(j,1) = long(ii(1));
    mat_out(j,2) = latg(ii(1));
    mat_out(j,3) = lon(j);
    mat_out(j,4) = lat(j);
    mat_out(j,5) = deg2km(d_min);
    mat_out(j,6) = rad(ii(1)); 
    clear d x y d_min
end
clear j ii
 
% % Ship canal 
ii = [17:19]; 
roi8_lat = [47.654 47.648 47.647 47.646 47.6468 47.6528 47.64 47.642 47.658 47.663 47.665 47.668 47.672 47.674 47.667 47.666 47.66 47.643 47.654];
roi8_lon = [-122.323 -122.31 -122.276 -122.276 -122.31 -122.323 -122.335 -122.341 -122.372 -122.39 -122.4 -122.4055 -122.409 -122.409 -122.4 -122.39 -122.372 -122.335 -122.323];
in8 = inpolygon(lon,lat,roi8_lon,roi8_lat);

plot(mat_out(in8,6),Xvec_norm(in8),'kp','MarkerSize',10,'MarkerFaceColor','k'); hold on
plot(mat_out(ii,6),Xvec_norm(ii),'kp','MarkerSize',10,'MarkerFaceColor','k');
xlabel('L_V_I_I_R_S (nW cm^-^2 sr^-^1)'); ylabel('E_0 (\muW cm^-^2 nm^-^1)'); 
ax = gca; ax.GridColor = [0 0 0];  grid on;
set(gca,'FontSize',14);

Xmat = mout(:,2:end); 
X4 = [mat_out(in8,6);mat_out(ii,6)];
Y4 = [Xvec_norm(in8);Xvec_norm(ii)]; 
light4 = [Xmat(in8,12);Xmat(ii,12)];
