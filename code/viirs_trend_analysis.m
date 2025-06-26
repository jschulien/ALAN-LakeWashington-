% viirs_trend_analysis.m

% This program will load the subsetted data imported using
% 'viirs_dnb_monthly_reader_2014_2023.m'

clear
close all

%% Create ROIs
% Northern pelagic 
roi1_lon = [-122.275 -122.27 -122.27 -122.26 -122.25 -122.25 -122.25 -122.26 -122.265 -122.27 -122.275]; roi1_lon = roi1_lon - 0.0025;
roi1_lat = [47.74 47.74 47.73 47.71 47.7 47.695 47.695 47.695 47.71 47.72 47.74];

% Middle pelagic north 
roi2_lat = [47.69 47.69 47.66 47.657 47.648 47.649 47.66 47.6735 47.685 47.69];
roi2_lon = [-122.245 -122.225 -122.225 -122.241 -122.248 -122.26 -122.255 -122.236 -122.239 -122.245];

% North suspension bridge
roi3_lat = [47.643 47.641 47.638 47.64 47.643];
roi3_lon = [-122.269 -122.25 -122.25 -122.269 -122.269];

% Ship canal 
roi8_lat = [47.654 47.648 47.647 47.646 47.6468 47.6528 47.64 47.642 47.658 47.663 47.665 47.668 47.672 47.674 47.667 47.666 47.66 47.643 47.654];
roi8_lon = [-122.323 -122.31 -122.276 -122.276 -122.31 -122.323 -122.335 -122.341 -122.372 -122.39 -122.4 -122.4055 -122.409 -122.409 -122.4 -122.39 -122.372 -122.335 -122.323];

% South suspension bridge 
roi4_lat = [47.5879 47.5879 47.592 47.592 47.5879];
roi4_lon = [-122.26 -122.278 -122.278 -122.26 -122.26]; 

% Southeast bridge 
roi9_lat = [47.58065 47.58075 47.5765 47.5765 47.58065];
roi9_lon = [-122.204 -122.197 -122.197 -122.204 -122.204];

% Middle pelagic 3/south 
roi10_lat = [47.58075 47.58075 47.566 47.555 47.541 47.541 47.555 47.568 47.568 47.58075];
roi10_lon = [-122.278 -122.26 -122.2375 -122.2375 -122.25 -122.254 -122.24 -122.25 -122.262 -122.278];

% Southwest pelagic
roi5_lat = [47.5349 47.535 47.52 47.515 47.51 47.516 47.52 47.5349];
roi5_lon = [-122.2565 -122.2515 -122.2315 -122.2165 -122.2165 -122.2365 -122.2465 -122.2565];

% Middle pelagic 2/middle 
roi6_lat = [47.63 47.63 47.608 47.608 47.6 47.6 47.6 47.63];
roi6_lon = [-122.268 -122.25 -122.25 -122.23 -122.23 -122.25 -122.268 -122.268];

% Southeast pelagic 
roi11_lat = [47.52 47.538 47.56 47.56 47.538 47.525 47.52];
roi11_lon = [-122.2165 -122.203 -122.203 -122.205 -122.205 -122.22 -122.2165];

% SR 520 suspension bridge high-rises 
roi12_lat = [47.6438 47.6435 47.6423 47.6275 47.6275 47.641 47.641 47.6438];
roi12_lon = [-122.281 -122.27425 -122.2703 -122.2703 -122.27425 -122.27425 -122.281 -122.281]; roi12_lon = roi12_lon - 0.005;

% I90 suspension bridge tower/nearshore 
roi13_lat = [47.5912 47.5912 47.5875 47.5875 47.5912];
roi13_lon = [-122.285 -122.275 -122.275 -122.285 -122.285]; roi13_lon = roi13_lon-0.0075;

% Boeing-Renton 
roi14_lat = [47.502 47.5045 47.5025 47.498 47.502];
roi14_lon = [-122.218 -122.206 -122.203 -122.218 -122.218];

% Nearshore southsouthwest 
roi17_lat = [47.503 47.5125 47.514 47.521 47.521 47.512 47.509 47.498 47.503];
roi17_lon = [-122.22 -122.238 -122.25 -122.258 -122.265 -122.25 -122.238 -122.22 -122.22];

% Nearshore east 
roi18_lat = [47.53 47.53 47.548 47.548 47.538 47.53];
roi18_lon = [-122.259 -122.266 -122.26 -122.256 -122.259 -122.259];

% Nearshore southcentral west 
roi19_lat = [47.55 47.585 47.585 47.558 47.55];
roi19_lon = [-122.259 -122.295 -122.285 -122.259 -122.259];

% Nearshore central west 
roi20_lat = [47.592 47.592 47.619 47.619 47.592];
roi20_lon = [-122.285 -122.29 -122.282 -122.279 -122.285];

% Gene Coulon Park 
roi16_lat = [47.50425 47.513 47.5185 47.5185 47.512 47.50425 47.50425];
roi16_lon = [-122.2 -122.204 -122.2105 -122.213 -122.205 -122.204 -122.2];

% Nearshore north of Gene Coulon Park 
roi32_lat = [47.519 47.519 47.5335 47.5335 47.519];
roi32_lon = [-122.2105 -122.213 -122.204 -122.199 -122.2105];

% Sammamish Slough 
roi15_lat = [47.6525 47.6525 47.6555 47.665 47.671 47.673 47.689 47.7 47.731 47.76 47.76 47.755 47.7624 47.751 47.757 47.757 47.752 47.749 47.746 47.757 47.752 47.755 47.755 47.73 47.7 47.688 47.673 47.669 47.665 47.6525];
roi15_lon = [-122.115 -122.11 -122.11 -122.125 -122.125 -122.13 -122.13 -122.142 -122.14 -122.172 -122.179 -122.1925 -122.205 -122.215 -122.245 -122.256 -122.256 -122.22 -122.212 -122.205 -122.1925 -122.179 -122.175 -122.1459 -122.146 -122.135 -122.135 -122.129 -122.129 -122.115];

% Nearshore northcentral west 
roi21_lat = [47.655 47.684 47.688 47.688 47.684 47.655 47.655];
roi21_lon = [-122.278 -122.248 -122.265 -122.25 -122.242 -122.268 -122.278];

% Nearshore north west 
roi22_lat = [47.69 47.74 47.74 47.69 47.69];
roi22_lon = [-122.27 -122.29 -122.282 -122.263 -122.27];

% Nearshore north 
roi23_lat = [47.744 47.744 47.755 47.755 47.76 47.76 47.744];
roi23_lon = [-122.29 -122.28 -122.268 -122.261 -122.261 -122.269 -122.29];

% Nearshore northeast 
roi24_lat = [47.75 47.75 47.739 47.712 47.702 47.699 47.696 47.7 47.71 47.739 47.75];
roi24_lon = [-122.261 -122.257 -122.263 -122.252 -122.242 -122.231 -122.231 -122.246 -122.257 -122.268 -122.261];

% Nearshore northcentral east 
roi25_lat = [47.695 47.695 47.68 47.676 47.676 47.68 47.695];
roi25_lon = [-122.22 -122.215 -122.212 -122.207 -122.212 -122.217 -122.22];

% Nearshore Kirkland
roi26_lat = [47.6744 47.6744 47.65 47.65 47.6744];
roi26_lon = [-122.21 -122.204 -122.204 -122.21 -122.21];

% Nearshore central
roi27_lat = [47.648 47.648 47.625 47.625 47.648];
roi27_lon = [-122.244 -122.239 -122.239 -122.244 -122.244];

% Nearshore central southeast 
roi28_lat = [47.6225 47.6225 47.607 47.609 47.6225];
roi28_lon = [-122.247 -122.238 -122.221 -122.232 -122.247];

% Nearshore northeast of Mercer Island
roi29_lat = [47.606 47.606 47.58 47.58 47.606];
roi29_lon = [-122.218 -122.213 -122.198 -122.203 -122.218];

% Nearshore Mercer Island northeast
roi30_lat = [47.58 47.58 47.587 47.587 47.58];
roi30_lon = [-122.205 -122.21 -122.228 -122.222 -122.205];

% Nearshore Mercer Island north 
roi7_lat = [47.589 47.589 47.595 47.595 47.589];
roi7_lon = [-122.24 -122.223 -122.223 -122.24 -122.24];

% Lake Sammamish
% Nearshore north Lake Sammamish 
roi31_lat = [47.652 47.653 47.657 47.656 47.652];
roi31_lon = [-122.104 -122.094 -122.094 -122.104 -122.104];

% Nearshore south Lake Sammamish 
roi36_lat = [47.5535 47.559 47.5648 47.558 47.5535];
roi36_lon = [-122.08 -122.056 -122.0555 -122.08 -122.08];

% Nearshore east Lake Sammamish 
roi33_lat = [47.566 47.566 47.59 47.615 47.635 47.652 47.652 47.633 47.615 47.59 47.566];
roi33_lon = [-122.063 -122.054 -122.086 -122.065 -122.069 -122.09 -122.094 -122.074 -122.0725 -122.092 -122.063];

% Nearshore west Lake Sammamish 
roi34_lat = [47.5605 47.5605 47.568 47.572 47.61 47.627 47.634 47.651 47.651 47.634 47.627 47.61 47.576 47.568 47.5605];
roi34_lon = [-122.077 -122.082 -122.085 -122.113 -122.113 -122.088 -122.09 -122.115 -122.105 -122.085 -122.084 -122.106 -122.108 -122.08 -122.077];

% Lake Sammamish pelagic
roi35_lat = [47.605 47.628 47.648 47.648 47.63 47.615 47.605 47.582 47.564 47.564 47.572 47.582 47.605];
roi35_lon = [-122.103 -122.08 -122.098 -122.094 -122.076 -122.078 -122.095 -122.095 -122.067 -122.073 -122.083 -122.103 -122.103];

%% Load VIIRS data
tic
path = '/Users/jschulien/MATLAB/ALAN/data/VIIRS/VIIRS_2014_2023'; cd(path);
load('viirs_subset_2014_2023_sl.mat'); % 08/2022 not included in this matrix, added below 

addpath('/Users/jschulien/m_map')
D = D(4:end); % There are no data for file 1-5

% Create date vector from filename
for i = 1:size(D,1)
    currD = D(i).name;
    year{i} = currD(11:14); 
    month{i} = currD(15:16); 
end
year = str2double(year); month = str2double(month); 
toc

% Load and subset data for 08/2022 (data were collected from different satellite)
tic
load('SVDNB_202208_75N180W.mat') % cf_cvg.tiff
cf_cvg = SVDNB_j01_20220801_20220831_75N180W_vcmslcfg_v10_c202209231200_; clear SVDNB_j01_20220801_20220831_75N180W_vcmslcfg_v10_c202209231200_
cf_cvg = double(cf_cvg);

load('SVDNB_202208_75N180W_rad.mat') % rad.tiff
rad = SVDNB_j01_20220801_20220831_75N180W_vcmslcfg_v10_c202209231200_; clear SVDNB_j01_20220801_20220831_75N180W_vcmslcfg_v10_c202209231200_
rad = double(rad); 

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
toc

% Merge the datasets
cf_cvg_cell = [cf_cvg_cell cf_cvg]; clear cf_cvg
rad_cell = [rad_cell rad]; clear rad
month = [month 8];
year = [year 2022]; 
clear lat_cell lon_cell

%% Identify pixels within each ROI
tic
sum_rad_out = []; latt = lat; lont = lon; 
for i = 1:size(rad_cell,2)
    radt = rad_cell{i};
    [long,latg] = meshgrid(lont,latt);
    in1 = inpolygon(long,latg,roi1_lon,roi1_lat);
    rad_roi1 = sum(radt(in1));
    n1 = numel(long(in1));
    in2 = inpolygon(long,latg,roi2_lon,roi2_lat);
    rad_roi2 = sum(radt(in2));
    n2 = numel(long(in2));
    in3 = inpolygon(long,latg,roi3_lon,roi3_lat);
    rad_roi3 = sum(radt(in3));
    n3 = numel(long(in3));
    in4 = inpolygon(long,latg,roi4_lon,roi4_lat);
    rad_roi4 = sum(radt(in4));
    n4 = numel(long(in4));
    in5 = inpolygon(long,latg,roi5_lon,roi5_lat);
    rad_roi5 = sum(radt(in5));
    n5 = numel(long(in5));
    in6 = inpolygon(long,latg,roi6_lon,roi6_lat);
    rad_roi6 = sum(radt(in6));
    n6 = numel(long(in6));
    in8 = inpolygon(long,latg,roi8_lon,roi8_lat);
    rad_roi8 = sum(radt(in8));
    n8 = numel(long(in8));
    in9 = inpolygon(long,latg,roi9_lon,roi9_lat);
    rad_roi9 = sum(radt(in9));
    n9 = numel(long(in9));
    in10 = inpolygon(long,latg,roi10_lon,roi10_lat);
    rad_roi10 = sum(radt(in10));
    n10 = numel(long(in10));
    in11 = inpolygon(long,latg,roi11_lon,roi11_lat);
    rad_roi11 = sum(radt(in11));
    n11 = numel(long(in11));
    in12 = inpolygon(long,latg,roi12_lon,roi12_lat);
    rad_roi12 = sum(radt(in12));
    n12 = numel(long(in12));
    in13 = inpolygon(long,latg,roi13_lon,roi13_lat);
    rad_roi13 = sum(radt(in13));
    n13 = numel(long(in13));
    in14 = inpolygon(long,latg,roi14_lon,roi14_lat);
    rad_roi14 = sum(radt(in14));
    n14 = numel(long(in14));
    in15 = inpolygon(long,latg,roi15_lon,roi15_lat);
    rad_roi15 = sum(radt(in15));
    n15 = numel(long(in15));
    in16 = inpolygon(long,latg,roi16_lon,roi16_lat);
    rad_roi16 = sum(radt(in16));
    n16 = numel(long(in16));
    in17 = inpolygon(long,latg,roi17_lon,roi17_lat);
    rad_roi17 = sum(radt(in17));
    n17 = numel(long(in17));
    in18 = inpolygon(long,latg,roi18_lon,roi18_lat);
    rad_roi18 = sum(radt(in18));
    n18 = numel(long(in18));
    in19 = inpolygon(long,latg,roi19_lon,roi19_lat);
    rad_roi19 = sum(radt(in19));
    n19 = numel(long(in19));
    in20 = inpolygon(long,latg,roi20_lon,roi20_lat);
    rad_roi20 = sum(radt(in20));
    n20 = numel(long(in20));
    in21 = inpolygon(long,latg,roi21_lon,roi21_lat);
    rad_roi21 = sum(radt(in21));
    n21 = numel(long(in21));
    in22 = inpolygon(long,latg,roi22_lon,roi22_lat);
    rad_roi22 = sum(radt(in22));
    n22 = numel(long(in22));
    in23 = inpolygon(long,latg,roi23_lon,roi23_lat);
    rad_roi23 = sum(radt(in23));
    n23 = numel(long(in23));
    in24 = inpolygon(long,latg,roi24_lon,roi24_lat);
    rad_roi24 = sum(radt(in24));
    n24 = numel(long(in24));
    in25 = inpolygon(long,latg,roi25_lon,roi25_lat);
    rad_roi25 = sum(radt(in25));
    n25 = numel(long(in25));
    in26 = inpolygon(long,latg,roi26_lon,roi26_lat);
    rad_roi26 = sum(radt(in26));
    n26 = numel(long(in26));
    in27 = inpolygon(long,latg,roi27_lon,roi27_lat);
    rad_roi27 = sum(radt(in27));
    n27 = numel(long(in27));
    in28 = inpolygon(long,latg,roi28_lon,roi28_lat);
    rad_roi28 = sum(radt(in28));
    n28 = numel(long(in28));
    in29 = inpolygon(long,latg,roi29_lon,roi29_lat);
    rad_roi29 = sum(radt(in29));
    n29 = numel(long(in29));
    in30 = inpolygon(long,latg,roi30_lon,roi30_lat);
    rad_roi30 = sum(radt(in30));
    n30 = numel(long(in30));
    in7 = inpolygon(long,latg,roi7_lon,roi7_lat);
    rad_roi7 = sum(radt(in7));
    n7 = numel(long(in7));

    in31 = inpolygon(long,latg,roi31_lon,roi31_lat);
    rad_roi31 = sum(radt(in31));
    n31 = numel(long(in31));
    in32 = inpolygon(long,latg,roi32_lon,roi32_lat);
    rad_roi32 = sum(radt(in32));
    n32 = numel(long(in32));
    in33 = inpolygon(long,latg,roi33_lon,roi33_lat);
    rad_roi33 = sum(radt(in33));
    n33 = numel(long(in33));
    in34 = inpolygon(long,latg,roi34_lon,roi34_lat);
    rad_roi34 = sum(radt(in34));
    n34 = numel(long(in34));
    in35 = inpolygon(long,latg,roi35_lon,roi35_lat);
    rad_roi35 = sum(radt(in35));
    n35 = numel(long(in35));
    in36 = inpolygon(long,latg,roi36_lon,roi36_lat);
    rad_roi36 = sum(radt(in36));
    n36 = numel(long(in36));

    outt = [rad_roi1,rad_roi2,rad_roi3,rad_roi4,rad_roi5,rad_roi6,rad_roi7,rad_roi8,rad_roi9,rad_roi10,rad_roi11,rad_roi12,rad_roi13,rad_roi14,rad_roi15,rad_roi16,rad_roi17,rad_roi18,rad_roi19,rad_roi20,rad_roi21,rad_roi22,rad_roi23,rad_roi24,rad_roi25,rad_roi26,rad_roi27,rad_roi28,rad_roi29,rad_roi30,rad_roi31,rad_roi32,rad_roi33,rad_roi34,rad_roi35,rad_roi36];
    sum_rad_out = [sum_rad_out;outt];
end
toc

num_pixels_out = [n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,n13,n14,n15,n16,n17,n18,n19,n20,n21,n22,n23,n24,n25,n26,n27,n28,n29,n30,n31,n32,n33,n34,n35,n36];

%% Plot trends in Lntl for each ROI (Summer months only)
ind = find(month == 6 | month == 7 | month == 8 | month == 9);
day = repmat(15,size(month(ind),2),1);
dates = datenum([year(ind)',month(ind)',day]); 
a = repmat(num_pixels_out,119,1); % 119 is number of files/dates
% mean_rad_out = sum_rad_out(ind,:)./a(ind,:); clear a
% mean_vec = nanmean(mean_rad_out);
year = year(1,ind); month = month(1,ind); 
sum_rad_out = sum_rad_out(ind,:); 
clear day ind
 
% figure; hb = bar(mean_vec);
% hb(1).FaceColor = 'k';
% hb(2).FaceColor = [0.7, 0.7, 0.7]; 
% hb(1).EdgeColor = 'k';
% hb(2).EdgeColor = [0.4, 0.4, 0.4];
% hb(1).BarWidth = 1; hb(2).BarWidth = 1;
% xticks(1:30);
% lbls = ({'Northern pelagic','Middle pelagic north','SR 520 suspension bridge','I90 suspension bridge','Southwest pelagic','Middle pelagic middle','Ship canal','East I-90 bridge','Middle pelagic south','Southeast pelagic','SR-520 suspension bridge high-rises','I-90 suspension bridge tower/nearshore','Boeing-Renton','Sammamish Slough','Gene Coulon Park','Nearshore southsouthwest','Nearshore northsouth west','Nearshore southcentral west','Nearshore central west','Nearshore northcentral west','Nearshore north west','Nearshore north','Nearshore northeast','Nearshore northcentral east','Nearshore Kirkland','Nearshore central','Nearshore central southeast','Nearshore northeast of Mercer Isl.','Nearshore Mercer Isl. northeast','Nearshore Mercer Isl. north','Nearshore north of Gene Coulon Park'});
% set(gca,'XTickLabel',lbls)
% ylabel('Average pixel L_V_I_I_R_S (nW cm^2 sr^-^1)');
% set(gca,'FontSize',14)
% grid on 

%% Trend Statistics
p_vec = [];  s_vec = [];  s_vec_robust = []; p_vec_robust = []; p_vec_mk = []; t_vec = []; r2_vec= []; 

for i = 1:size(sum_rad_out, 2)  
    X = dates;  y = sum_rad_out(:, i); 
    
    figure; plot(X, y, 'k.', 'MarkerSize', 15); hold on;
    
    % Theil-Sen estimator
    [H,p_value_mk] = Mann_Kendall(y,0.05);
    p_vec_mk = [p_vec_mk; p_value_mk];  % Store p-value from Robust fit slope
    [coef, rsqrd] = TheilSen(X, y);  % coef = slope and intercept from TheilSen
    
    % Perform robust fitting
    [B, Stats] = robustfit(X, y);
    % Store the p-value and slope in vectors
    p_vec_robust = [p_vec_robust; Stats.p(1)];  % Store p-value from Robust fit slope
    s_vec_robust = [s_vec_robust, B(1)];  % Store slope from Robust fit
    
    % Perform Generalized Linear Model regression
    glm_model = fitglm(X, y, 'linear');  % Fit a GLM with a linear link function
    
    % Extract coefficients from GLM
    slope_glm = glm_model.Coefficients.Estimate(2);  % Slope (X coefficient)
    intercept_glm = glm_model.Coefficients.Estimate(1);  % Intercept (constant term)
    p_value_glm = glm_model.Coefficients.pValue(2);  % p-value for slope
    t_stat_glm = glm_model.Coefficients.tStat(2);  
    r2_glm = glm_model.Rsquared.Adjusted;
    
    % Store the p-value and slope in vectors
    p_vec = [p_vec; p_value_glm];  % Store p-value from GLM
    t_vec = [t_vec; t_stat_glm];  
    s_vec = [s_vec; slope_glm];  % Store slope from GLM
    r2_vec = [r2_vec; r2_glm];
    
    % Plot the GLM regression line if p-value is significant
    if p_value_glm <= 0.05
        yt = (slope_glm * X) + intercept_glm;
        plot(X, yt, 'r-', 'LineWidth', 2);  % Plot GLM regression line
    end
    grid on; 
end
