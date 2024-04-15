clc 
clearvars
close all

%% read data
data = readtable('AP_dual_spoiler_TSEsetting/gantryN/EnergyDepositInPVC.csv');
APUpper_c = reshape(table2array(data(:,4)),[4,240,120]);

data = readtable('AP_dual_spoiler_TSEsetting/gantryP/EnergyDepositInPVC.csv');
APLower_c = reshape(table2array(data(:,4)),[4,240,120]);

data = readtable('AP_dual_spoiler_block_TSEsetting/gantryN/EnergyDepositInPVC.csv');
APUpper = reshape(table2array(data(:,4)),[4,240,120]);

data = readtable('AP_dual_spoiler_block_TSEsetting/gantryP/EnergyDepositInPVC.csv');
APLower = reshape(table2array(data(:,4)),[4,240,120]);


%%
APDual_c = APUpper_c + APLower_c;
APDual = APUpper + APLower;

% center locations for each bin:
xgrid = ((1:120)-1)*1 - 60 + 0.5;    % -60 ~ 60cm, 120 bins
ygrid = ((1:240)-1)*1 - 120 - 12 + 0.5; % -132 ~ 118cm, 240 bins
zgrid = ((1:4)-1)*0.2 + 0.1; % 0 ~ 0.8cm, 4 bins

%%
zid = 1;

APUpper_z = squeeze(APUpper(zid,:,:));
APLower_z = squeeze(APLower(zid,:,:));
APDual_z = squeeze(APDual(zid,:,:));

APDual_c_z = squeeze(APDual_c(zid,:,:));

figure(1)
clf
subplot(1,3,1)
imagesc(xgrid,ygrid,APUpper_z)
axis image
colorbar
xlabel('X (cm)')
ylabel('Y (cm)')
hold on
xline(0,'--r','LineWidth',1.5)
yline(-132+160,'--r','LineWidth',1.5)
set(gca,'Ydir','normal')
title('AP Upper')
clim([0,450])

subplot(1,3,2)
imagesc(xgrid,ygrid,APLower_z)
axis image
colorbar
xlabel('X (cm)')
ylabel('Y (cm)')
hold on
xline(0,'--r','LineWidth',1.5)
yline(-132+160,'--r','LineWidth',1.5)
set(gca,'Ydir','normal')
title('AP Lower')
clim([0,800])

subplot(1,3,3)
imagesc(xgrid,ygrid,APDual_z)
axis image
colorbar
xlabel('X (cm)')
ylabel('Y (cm)')
hold on
xline(0,'--r','LineWidth',1.5)
yline(-132+160,'--r','LineWidth',1.5)
set(gca,'Ydir','normal')
title('AP Dual')
clim([0,850])

sgtitle(['Raw, z = ', num2str(zgrid(zid)),' cm']) 
%% get the profiles for select slices

xCenter = 120;
figure(2)
clf
plot(ygrid,APUpper_z(:,xCenter),'LineWidth',2)
hold on
plot(ygrid,APLower_z(:,xCenter),'LineWidth',2)
plot(ygrid,APDual_z(:,xCenter),'LineWidth',2)
plot(ygrid,APDual_c_z(:,xCenter),'LineWidth',2)
xlabel('Y (cm)')
xlim([-132,108])
grid on
ylabel('Energy deposit (MeV)')
h = legend('APUpper','APLower','APDual','APDual no block','Location','east');
h.AutoUpdate = 'off';
xline(-132+160,'--r','LineWidth',1.5);
set(gca,'FontSize',13,'LineWidth',1.5)
xticks(-132:20:108)
title(['z = ', num2str(zgrid(zid)),' cm'])


%% smooth
s = 11;
for i = 1:length(zgrid)
    APDual_sm(i,:,:) = smoothn(squeeze(APDual(i,:,:)),s);
    APLower_sm(i,:,:) = smoothn(squeeze(APLower(i,:,:)),s);
    APUpper_sm(i,:,:) = smoothn(squeeze(APUpper(i,:,:)),s);

    APDual_c_sm(i,:,:) = smoothn(squeeze(APDual_c(i,:,:)),s);
end

%
APUpper_sm_z = squeeze(APUpper_sm(zid,:,:));
APLower_sm_z = squeeze(APLower_sm(zid,:,:));
APDual_sm_z = squeeze(APDual_sm(zid,:,:));

APDual_c_sm_z = squeeze(APDual_c_sm(zid,:,:));


%%
figure(3)
clf
subplot(1,3,1)
imagesc(xgrid,ygrid,APUpper_sm_z)
axis image
colorbar
xlabel('X (cm)')
ylabel('Y (cm)')
hold on
xline(0,'--r','LineWidth',1.5)
yline(-132+160,'--r','LineWidth',1.5)
set(gca,'Ydir','normal')
title('AP Upper')
clim([0,450])

subplot(1,3,2)
imagesc(xgrid,ygrid,APLower_sm_z)
axis image
colorbar
xlabel('X (cm)')
ylabel('Y (cm)')
hold on
xline(0,'--r','LineWidth',1.5)
yline(-132+160,'--r','LineWidth',1.5)
set(gca,'Ydir','normal')
title('AP Lower')
clim([0,800])

subplot(1,3,3)
imagesc(xgrid,ygrid,APDual_sm_z)
axis image
colorbar
xlabel('X (cm)')
ylabel('Y (cm)')
hold on
xline(0,'--r','LineWidth',1.5)
yline(-132+160,'--r','LineWidth',1.5)
set(gca,'Ydir','normal')
title('AP Dual')
clim([0,850])

sgtitle(['Smoothed (s=',num2str(s) ,'), z = ', num2str(zgrid(zid)),' cm']) 

%% Spline
figure(6)
clf
APDual_z_gaus = imgaussfilt(APDual_z,10);
APDual_c_gaus = imgaussfilt(APDual_c,10);
% Plot the original points and the spline interpolation
plot(x, APDual_z_gaus, 'b-',x, APDual_c_gaus, 'r-')

%%
figure(4)
clf
plot(ygrid,APUpper_sm_z(:,xCenter),'LineWidth',2)
hold on
plot(ygrid,APLower_sm_z(:,xCenter),'LineWidth',2)
plot(ygrid,APDual_sm_z(:,xCenter),'LineWidth',2)
plot(ygrid,APDual_c_sm_z(:,xCenter),'LineWidth',2)
xlabel('Y (cm)')
xlim([-132,108])
grid on
ylabel('Energy deposit (MeV)')
h = legend('APUpper','APLower','APDual','APDual no block','Location','east');
h.AutoUpdate = 'off';
xline(-132+160,'--r','LineWidth',1.5);
set(gca,'FontSize',13,'LineWidth',1.5)
xticks(-132:20:108)
title(['Smoothed (s=',num2str(s) ,'), z = ', num2str(zgrid(zid)),' cm']) 

%%
figure(5)
clf
scatter(ygrid,APUpper_z(:,xCenter),'o','filled','LineWidth',2)
hold on
scatter(ygrid,APLower_z(:,xCenter),'o','filled','LineWidth',2)
scatter(ygrid,APDual_z(:,xCenter),'o','filled','LineWidth',2)
scatter(ygrid,APDual_c_z(:,xCenter),'o','filled','LineWidth',2)
xlabel('Y (cm)')
xlim([-132,108])
grid on
ylabel('Energy deposit (MeV)')
h = legend('APUpper','APLower','APDual','APDual no block','Location','east');
h.AutoUpdate = 'off';
plot(ygrid,APUpper_sm_z(:,xCenter),'LineWidth',2,'Color',[0 0.4470 0.7410])
plot(ygrid,APLower_sm_z(:,xCenter),'LineWidth',2,'Color',[0.8500 0.3250 0.0980])
plot(ygrid,APDual_sm_z(:,xCenter),'LineWidth',2,'Color',[0.9290 0.6940 0.1250])
plot(ygrid,APDual_c_sm_z(:,xCenter),'LineWidth',2,'Color',[0.4940 0.1840 0.5560])
xline(-132+160,'r','LineWidth',1.5);
xticks(-132:20:108)
title(['Smoothed (s=',num2str(s) ,'), z = ', num2str(zgrid(zid)),' cm']) 
set(gca,'FontSize',13,'LineWidth',1.5)

%%
APUpper_sum = squeeze(sum(APUpper,1));
APLower_sum = squeeze(sum(APLower,1));
APDual_sum = squeeze(sum(APDual,1));
APDual_c_sum = squeeze(sum(APDual_c,1));

APUpper_sm_sum = squeeze(sum(APUpper_sm,1));
APLower_sm_sum = squeeze(sum(APLower_sm,1));
APDual_sm_sum = squeeze(sum(APDual_sm,1));
APDual_c_sm_sum = squeeze(sum(APDual_c_sm,1));

figure(6)
clf
plot(ygrid,APUpper_sum(:,xCenter),'--','LineWidth',2)
hold on
plot(ygrid,APLower_sum(:,xCenter),'--','LineWidth',2)
plot(ygrid,APDual_sum(:,xCenter),'--','LineWidth',2)
plot(ygrid,APDual_c_sum(:,xCenter),'--','LineWidth',2)
xlabel('Y (cm)')
xlim([-132,108])
grid on
ylabel('Energy deposit (MeV)')
h = legend('APUpper','APLower','APDual','APDual no block','Location','east');
h.AutoUpdate = 'off';
plot(ygrid,APUpper_sm_sum(:,xCenter),'LineWidth',2,'Color',[0 0.4470 0.7410])
plot(ygrid,APLower_sm_sum(:,xCenter),'LineWidth',2,'Color',[0.8500 0.3250 0.0980])
plot(ygrid,APDual_sm_sum(:,xCenter),'LineWidth',2,'Color',[0.9290 0.6940 0.1250])
plot(ygrid,APDual_c_sm_sum(:,xCenter),'LineWidth',2,'Color',[0.4940 0.1840 0.5560])
xline(-132+160,'r','LineWidth',1.5);
xticks(-132:20:108)
title(['Smoothed (s=',num2str(s) ,'), Z = 0 ~ 0.8cm']) 
set(gca,'FontSize',13,'LineWidth',1.5)




