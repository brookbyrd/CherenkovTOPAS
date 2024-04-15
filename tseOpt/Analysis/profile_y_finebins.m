filename = 'DoseInPVC.csv';
%filename = 'Dose4M_151540.csv';
dose = csvread(filename,8,0);
format long;
xy = zeros(1440, 24);
xz = zeros(1440, 24);
xdose = zeros(1440, 24);

rowdist= 1440*ones(1, 24);
ddose = mat2cell(dose, rowdist);

marker = 80*ones(1, 30);
color = 1:1:30;
%S = repmat(marker, 40, 1);
%C = repmat(color, 40, 1);
s = marker';
c = color';

slicey = 27; % isocenter y height = 132 cm. 
for n = 1:24
  posx(:,n) = ddose{n,1}((slicey-1)*30+1: slicey*30,1);
  posy(:,n) = ddose{n,1}((slicey-1)*30+1: slicey*30,2);
  posz(:,n) = ddose{n,1}((slicey-1)*30+1: slicey*30,3);
  sdose(:,n) = ddose{n,1}((slicey-1)*30+1: slicey*30,4);
  %scatter3((xy(:,n)+1).*4., 20-(xz(:,n)+1).*0.5, sdose(:,n), s, c);
  %hold on;
end;

% maximum dose at slicey=7, slicex =9
% PDD at Y=0 (slicey 8), X=0 (slicex 8)
f1 = figure;
f2 = figure;
f3 = figure;
figure(f1);
slicex = 13; % isocenter slice x = 60
maxd = max(sdose(:,slicex));
pdd = sdose(:,slicex)/maxd;
scatter((posz(:,slicex)+0.5).*0.2, pdd, s, c);
title("Depth Dose  Y-Slice 0cm")
%xlabel("X Direction (cm)");
xlabel("Z Depth (cm)");
ylabel("PDD ");
ylim([-0.01, 1.1]);
xlim([0, 10]);

figure(f2);
profx = (posx(1, :)+0.5)*5 -60;
p1 = plot(profx, sdose(1,:), '-.ob', "Linewidth", 2.0);
hold on;
%p2 = plot(profx, sdose(2,:), '-+r',"Linewidth", 2.0);
%hold on;
p3 = plot(profx, sdose(3,:), '-xg',"Linewidth", 2.0);
hold on;
%p4 = plot(profx, sdose(4,:), ':^b',"Linewidth", 2.0);
%hold on;
p5 = plot(profx, sdose(5,:), '--*k',"Linewidth", 2.0);
hold on;
p6 = plot(profx, sdose(6,:), '--<c',"Linewidth", 2.0);
hold on;
p7 = plot(profx, sdose(7,:), '-.>m',"Linewidth", 2.0);
hold on;
%p8 = plot(profx, sdose(8,:), ':_y',"Linewidth", 2.0);
%hold on;
%legend([p1, p2, p3, p4, p5, p6, p7, p8], ...
%    'Z = 0.1 cm','Z = 0.3 cm','Z = 0.5 cm', 'Z = 0.7 cm', ...
%    'Z = 0.9 cm','Z = 1.1 cm','Z = 1.3 cm', 'Z = 1.5 cm')
legend([p1, p3, p5, p6, p7], ...
    'Z = 0.1 cm','Z = 0.5 cm', ...
    'Z = 0.9 cm','Z = 1.1 cm','Z = 1.3 cm')
title("Profile at Y=0cm")
xlabel("X Distance to Z-axis (cm)");
%ylabel("Z-Depth (cm)");
ylabel("Dose (Gy) ");
%ylim([-40, 40]);
xlim([-60, 60]);

figure(f3);
dpydmax = sdose(3,:)./sum(sdose(3,:));
xd2cax = -60+2.5 : 5 : 60-2.5;
scatter(xd2cax, dpydmax);

A = [xd2cax; dpydmax];
fileID = fopen('YProfileDmax.txt','w');
formatSpec = '%f %f\n';
fprintf(fileID, formatSpec, A);
fclose(fileID);
