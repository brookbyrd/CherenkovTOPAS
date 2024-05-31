

%% Setup files

% Define the directory containing the files
directory = '/Applications/topas/Annie_BKB/Output';

% Look up the quantum efficiency for each wavelength
gen3 = readtable('/Applications/topas/Annie_BKB/Matlab/gen3.csv', 'ReadVariableNames', false);

% Extract wavelength and QE columns
wavelengths = gen3.Var1;
qe = gen3.Var2/max(gen3.Var2);

% Define the anonymous function to interpolate QE values for each wavelength
interpolated_function = @(wavelength) interp1(wavelengths, qe, wavelength, 'linear');

phsp_data = readtable('/Applications/topas/Annie_BKB/Python/filtered_data.csv', 'ReadVariableNames', true);


%% Get the data out of processed phase space
% Filter energies and positions based on wavelengths between 400 and 800 nm
filtered_energies = phsp_data.Energy;
filtered_wavelengths = phsp_data.Wavelength;
filtered_positions_temp = phsp_data.Position;
filtered_original_positions_temp = phsp_data.Original_Position;
filtered_angular_weights = phsp_data.Angular_Weight;
filtered_directions_temp = phsp_data.Direction_Cosines;
filtered_qe_weights = arrayfun(interpolated_function, filtered_wavelengths);

%%
for f = 1:length(filtered_directions_temp)
    filtered_directions(f,:) = str2double(strsplit(strrep(strrep(filtered_directions_temp{f}, '(', ''), ')', ''), ','));
    filtered_original_positions(f,:) = str2double(strsplit(strrep(strrep(filtered_original_positions_temp{f}, '(', ''), ')', ''), ','));
    filtered_positions(f,:) = str2double(strsplit(strrep(strrep(filtered_positions_temp{f}, '(', ''), ')', ''), ','));
end

%%
bins = 100;

% Calculate the histogram for starting positions
[regular_original_histogram, xedges, yedges] = histcounts2(filtered_original_positions(:, 1), filtered_original_positions(:, 2), 'NumBins', [bins, bins]);

% Plot the histogram for starting positions
subplot(1, 3, 1);

imshow(flipud(regular_original_histogram'),[]); hold on;
xticks([1:10:101]);
yticks([1:10:101]);
xedges_cell = arrayfun(@(x) num2str(x), [-25:5:26], 'UniformOutput', false);
yedges_cell = arrayfun(@(x) num2str(x), [-25:5:26], 'UniformOutput', false);
xticklabels(xedges_cell);
yticklabels(yedges_cell);
colormap hot;
colorbar;
title('Original Positions');
xlabel('X Position (cm)');
ylabel('Y Position (cm)');
set(gca, 'FontSize', 8);
axis on;


% Calculate the histogram for final positions
[regular_histogram, xedges, yedges] = histcounts2(filtered_positions(:, 1), filtered_positions(:, 2),  'NumBins', [bins, bins]);

% Plot the histogram for final positions
subplot(1, 3, 2);
imshow(flipud(regular_histogram'),[]); hold on;
xticks([1:10:101]);
yticks([1:10:101]);
xedges_cell = arrayfun(@(x) num2str(x), [-25:5:26], 'UniformOutput', false);
yedges_cell = arrayfun(@(x) num2str(x), [-25:5:26], 'UniformOutput', false);
xticklabels(xedges_cell);
yticklabels(yedges_cell);
colormap hot;
colorbar;
title('Final Chkv Photon Locations');
xlabel('X Position (cm)');
ylabel('Y Position (cm)');
set(gca, 'FontSize', 8);
axis on;

% Calculate the histogram for filtered positions
[filtered_histogram, xedges, yedges] = histcounts2(filtered_positions(:, 1), filtered_positions(:, 2), 'NumBins', [bins, bins], 'BinWeights', filtered_angular_weights .* filtered_qe_weights);

% Plot the histogram for filtered positions
subplot(1, 3, 3);
imshow(flipud(filtered_histogram'),[]); hold on;
xticks([1:10:101]);
yticks([1:10:101]);
xedges_cell = arrayfun(@(x) num2str(x), [-25:5:26], 'UniformOutput', false);
yedges_cell = arrayfun(@(x) num2str(x), [-25:5:26], 'UniformOutput', false);
xticklabels(xedges_cell);
yticklabels(yedges_cell);
colormap hot;
colorbar;
title('Filtered Chkv Image');
xlabel('X Position (cm)');
ylabel('Y Position (cm)');
set(gca, 'FontSize', 8);
axis on;

%%
% Save the images
output_path = fullfile('/Applications/topas/Annie_BKB/OutputCherenkovImages/', 'Cherenkov_final_positiions.tif');
imwrite(uint16(filtered_histogram'), output_path);

output_path = fullfile('/Applications/topas/Annie_BKB/OutputCherenkovImages/', 'Cherenkov_original_positiions.tif');
imwrite(uint16(regular_original_histogram'), output_path);

output_path = fullfile('/Applications/topas/Annie_BKB/OutputCherenkovImages/', 'Cherenkov_filtered_final_positiions.tif');
imwrite(uint16(regular_original_histogram'), output_path);

% Display the plot
set(gcf, 'Position', [0, 0, 1200, 400]); % Set figure size
set(gcf, 'PaperPositionMode', 'auto'); % Set paper size
tightfig;
drawnow;



%% Now in 3D

[regular_histogram, xedges, yedges] = histcounts3(filtered_positions(:, 1), filtered_positions(:, 2), 'BinLimits', [-25, 25], 'NumBins', [bins, bins, bins]);

