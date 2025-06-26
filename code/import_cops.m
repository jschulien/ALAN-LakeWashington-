% imports C-OPS day files
% Qa'Qc of data with histograms of pitch and roll for both in-water and reference arrays
% Calculates Kd(z)

clear; close all

%% Import data
path = '/Users/jschulien/MATLAB/ALAN/data/COPS/072424_day'; cd(path);

files = dir('*URC.csv'); cast = []; 
for i = 1:numel(files)
    names{i} = files(i).name; fname = char(names(i)); ct = fname(18:19); ct = str2double(ct); 
    Et = readtable(fname); 
    datetime = Et(:,1:4); Et = Et(:,5:end); 
    E{i} = table2array(Et); DT{i} = datetime; 
    cast = [cast;ct];
    % figure; plot(table2array(Eot(:,1))); 
end
clear i Eot fname datetime ct

hdr1 = {'Depth','Ed0 roll','Ed0 pitch','Edz roll','Edz pitch'};
wvl = [380, 395, 412, 443, 465, 490, 510, 532, 555, 560, 565, 589, 625, 665, 670, 683, 694, 710, 800]; 

idx_dark = [1,8,15,25,40]; 
id_cast = find(ismember(cast, idx_dark));
DT(id_cast) = []; dark = E(id_cast); cast(id_cast) = []; E(id_cast) = []; clear id_cast idx_dark

%% Calculate Dark Average/ Noise
Xdark = []; % XEd0 = []; XEdz = []; XLuz = []; 
for i = 1:size(dark,2)
    temp = dark{i};
    data = temp(:,6:end-4); 
    % Ed0 = data(:,1:19); Edz = data(:,20:38); Luz = data(:,39:end);
    % xEd0 = mean(Ed0); xEdz = mean(Edz); xLuz = mean(Luz);
    % XEd0 = [XEd0;xEd0]; XEdz = [XEdz;xEdz]; XLuz = [XLuz;xLuz];
    xdark = mean(data); Xdark = [Xdark;xdark];
end
clear xdark i temp data

% figure; subplot(3,1,1); plot(wvl(1:end-1),Xdark(:,1:18),'k-','LineWidth',0.5); hold on
% xlabel('Wavelength (nm)'); ylabel('E_d0 (\muW cm^-^2 nm^-^1)'); title('Dark Measurements'); 
% set(gca,'FontSize',12); grid on
% plot(wvl(1:end-1),mean(Xdark(:,1:18)),'r--','LineWidth',1);
% 
% subplot(3,1,2); plot(wvl(1:end-1),Xdark(:,20:37),'k-','LineWidth',0.5); hold on
% xlabel('Wavelength (nm)'); ylabel('E_dz (\muW cm^-^2 nm^-^1)'); title('Dark Measurements'); 
% set(gca,'FontSize',12); grid on
% plot(wvl(1:end-1),mean(Xdark(:,20:37)),'r--','LineWidth',1);
% 
% subplot(3,1,3); plot(wvl(1:end-1),Xdark(:,39:56),'k-','LineWidth',0.5); hold on
% xlabel('Wavelength (nm)'); ylabel('L_uz (\muW cm^-^2 nm^-^1)'); title('Dark Measurements'); 
% set(gca,'FontSize',12); grid on
% plot(wvl(1:end-1),mean(Xdark(:,39:56)),'r--','LineWidth',1);

xdark = mean(Xdark); clear Xdark

%% Evaluate pitch and roll of both the in-water and surface-mounted sensors
Ed0_roll = []; Ed0_pitch = []; Edz_roll = []; Edz_pitch = []; 
for i = 1:size(E,2)
    temp = E{i};
%     figure; subplot(2,2,1); histogram(temp(:,2)); title('Ed0 roll'); hold on; xline(0,'r','LineWidth',1); grid on
%     subplot(2,2,2); histogram(temp(:,3)); title('Ed0 pitch'); hold on; xline(0,'r','LineWidth',1); grid on
%     subplot(2,2,3); histogram(temp(:,4)); title('Edz roll'); hold on; xline(0,'r','LineWidth',1); grid on
%     subplot(2,2,4); histogram(temp(:,5)); title('Edz pitch'); hold on; xline(0,'r','LineWidth',1); grid on
%     Ed0_roll = [Ed0_roll;temp(:,2)];
%     Ed0_pitch = [Ed0_pitch;temp(:,3)];
    Edz_roll = [Edz_roll;temp(:,4)];
    Edz_pitch = [Edz_pitch;temp(:,5)];
end

figure; % subplot(2,2,1); histogram(Ed0_roll); title('Ed0 roll: all casts'); hold on; xline(0,'r','LineWidth',1); grid on; xlim([-10 10]); ylabel('# Observations'); xlabel('Degrees'); set(gca,'FontSize',14); 
% subplot(2,2,2); histogram(Ed0_pitch); title('Ed0 pitch: all casts'); hold on; xline(0,'r','LineWidth',1); grid on; xlim([-10 10]); ylabel('# Observations'); xlabel('Degrees'); set(gca,'FontSize',14);
subplot(1,2,1); histogram(Edz_roll,50); title('Edz roll: all casts'); hold on; xline(0,'r','LineWidth',1); grid on; xlim([-10 10]); ylabel('# Observations'); xlabel('Degrees'); set(gca,'FontSize',14);
subplot(1,2,2); histogram(Edz_pitch); title('Edz pitch: all casts'); hold on; xline(0,'r','LineWidth',1); grid on; xlim([-10 10]); ylabel('# Observations'); xlabel('Degrees'); set(gca,'FontSize',14);

%% Remove instrument noise and Qa'Qc data
for i = 1:size(E,2)
    temp = E{i};
    data = temp(:,6:end-4); 
    dcorr = data - repmat(xdark,size(data,1),1); 
    idx = find(temp(:,4) < -5 | temp(:,4) > 5); dcorr(idx,:) = NaN; clear idx % Edz roll
    idx = find(temp(:,5) < -5 | temp(:,5) > 5); dcorr(idx,:) = NaN; clear idx % Edz pitch
    idx = find(isnan(dcorr(:,1))); dcorr(idx,:) = []; temp(idx,:) = []; clear idx
    data_corr{i} = [temp(:,1:5), dcorr];
end
clear i dcorr data temp

% Apply a 50 cell running mean 
for i = 1:size(data_corr,2)
    B = [];
    temp = data_corr{i}; 
    for j = 6:size(temp,2)
        a = temp(:,j);
        b = movmean(a,50);
        B = [B,b];
    end
    data_corr_smooth{i} = [temp(:,1:5), B];
    % figure; plot(b,temp(:,1),'r-','LineWidth',1); hold on; plot(a,temp(:,1),'k.-');
    % ylabel('Depth (m)'); xlabel('E_d (or L_u)'); grid on; set(gca,'FontSize',14);  set(gca, 'YDir','reverse')
end

clear B a b j i temp

%% Plot and average 3 casts collected at each station
i58 = [4,6,7]; id58 = find(ismember(cast, i58));
i1 = [9,11,18,19]; id1 = find(ismember(cast, i1));
i61 = [22,23,24]; id61 = find(ismember(cast, i61));
i18 = [26,27,28]; id18 = find(ismember(cast, i18));
i13 = [30,31,32]; id13 = find(ismember(cast, i13));
i10 = [33,34,36]; id10 = find(ismember(cast, i10));
i48 = [37,38,39]; id48 = find(ismember(cast, i48));

%% Station 470
% Ed0 = data(:,1:19); Edz = data(:,20:38); Luz = data(:,39:end);
c1 = data_corr_smooth{id58(1)};  
c2 = data_corr_smooth{id58(2)};  
c3 = data_corr_smooth{id58(3)};  
new_depth = 0.1:.5:40; 
d1 = c1(:,1); c1 = c1(:,6:end); 
D1 = interp1(d1,c1,new_depth,"spline"); 
d2 = c2(:,1); c2 = c2(:,6:end);
D2 = interp1(d2,c2,new_depth,"spline"); 
d3 = c3(:,1); c3 = c3(:,6:end); 
D3 = interp1(d3,c3,new_depth,"spline"); 
Xmat58 = (D1 + D2 + D3)./ 3;
 
% format long;  
Y =  new_depth; X = wvl; Z = Xmat58(:,20:38);
% Y =  new_depth; X = wvl(1:18); Z = Xmat58(:,20:37);
% minZ = min(Z(:)); maxZ = max(Z(:)); 
% levels = linspace(minZ, maxZ, 17); 
% figure; subplot(1,4,1)
% contourf(X,Y,Z,levels); 
% set(gca,'YDir','reverse')
% ylabel('Depth (m)'); xlabel('Wavelength (nm)'); grid on; 
% title('470: E_d');  
% set(gca,'FontSize',14);  set(gca, 'YDir','reverse')
% cb = colorbar; 
% ylabel(cb,'E_d (\muW cm^2 nm^-^1)','FontSize',12)
% ylim([0 40]);

% subplot(1,4,2)
% plot(Z(:,9),Y,'k.-','LineWidth',1,'MarkerSize',14); hold on
% set(gca,'YDir','reverse')
% % ylabel('Depth (m)'); 
% xlabel('E_d(555)'); grid on; 
% title('470: E_d(555)');  
% set(gca,'FontSize',14);  set(gca, 'YDir','reverse'); 
% ylim([0 40]);
% 
% plot(c1(:,29),d1,'r-','LineWidth',.5); 
% % plot(D1(:,29),new_depth,'r--','LineWidth',1); 
% plot(c2(:,29),d2,'r-','LineWidth',.5); 
% % plot(D2(:,29),new_depth,'r--','LineWidth',1); 
% plot(c3(:,29),d3,'r-','LineWidth',.5); 
% % plot(D3(:,29),new_depth,'r--','LineWidth',1); 
clear c1 c2 c3 d1 d2 d3 D1 D2 D3

Kd = []; 
for i = 1:size(Z,2)
    vec = Z(:,i);
    Kt = [];
    for j = 2:size(vec,1)
        if vec(j-1) < vec(j) || vec(j) <= 0
            kdt = NaN;
        else
            kdt = log(vec(j-1)./vec(j)) ./ (Y(j) - Y(j-1));
        end
        if kdt > 2 || kdt <= 0
            kdt = NaN; 
        end
        Kt = [Kt;kdt]; 
    end
    Kd = [Kd,Kt];
end

clear i j Kt kdt vec

% Create Kd depth vector to plot
d = Y(1:end-1);
