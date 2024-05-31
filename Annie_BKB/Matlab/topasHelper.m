classdef topasHelper
    methods (Static)
        function [energies, positions, direction_cosines, original_positions] = process_phsp_file(filename)
            % Open the file
            fileID = fopen(filename, 'r');

            % Initialize lists to store extracted data
            energies = [];
            positions = [];
            original_positions = [];
            direction_cosines = [];

            % Read file line by line
            tline = fgetl(fileID);
            while ischar(tline)
                % Split the line into columns
                columns = strsplit(tline);

                % Check if the line corresponds to a photon
                if strcmp(columns{8}, '-22')
                    energy = str2double(columns{6});  % Energy in MeV
                    position = [str2double(columns{1}), str2double(columns{2}), str2double(columns{3})];  % Positions X, Y, Z
                    original_position = [str2double(columns{14}), str2double(columns{15}), str2double(columns{16})];  % Positions X, Y, Z
                    direction_cosine = [str2double(columns{4}), str2double(columns{5}), str2double(columns{9})];  % Direction cosines X, Y, Z
                    energies = [energies; energy];
                    positions = [positions; position];
                    original_positions = [original_positions; original_position];
                    direction_cosines = [direction_cosines; direction_cosine];
                end

                % Read the next line
                tline = fgetl(fileID);
            end

            % Close the file
            fclose(fileID);
        end

        function wavelength_m = Mev_to_wavelength(energy_Mev)
            % Convert energy from MeV to wavelength in meters
            energy_joules = 10^6 * energy_Mev * e;
            wavelength_m = h * c / energy_joules;
        end

        function histogram = create_histogram(data, bins)
            % Accumulate the photons in a 2D histogram
            % Assuming data contains x, y positions
            histogram = hist3(data(:, 2:3), 'Edges', bins);
        end

        function camera_image = simulate_camera(histogram, intrinsic_params, extrinsic_params)
            % Simulate the virtual camera recording the photons
            % This is a placeholder function; you need to implement the camera model
            % using the intrinsic and extrinsic parameters provided
            % This function should project the 2D histogram onto the camera sensor
            camera_image = zeros(size(histogram));  % Placeholder for the camera image
        end

        function images = load_images(image_folder)
            images = {};
            files = dir(fullfile(image_folder, '*.tif'));
            for i = 1:length(files)
                filename = fullfile(image_folder, files(i).name);
                image = imread(filename);
                % Extracting mus and mua from filename
                parts = strsplit(files(i).name, {'_mus_', '_mua_'});
                mus = str2double(parts{2});
                mua = str2double(parts{3}(1:end-4));
                images{i} = struct('mus', mus, 'mua', mua, 'data', image);
            end
        end

        function [weights, polar_angle_degrees] = correct_angular_dependence(px, py, flag)
            % Corrects angular dependence in phase space data.

            if flag
                % Photon is traveling inwards of the z direction
                % pz_sign = -1
                pz_sign = 0;  % Do not use it
            else
                % Photon is traveling outwards of the z direction
                pz_sign = 1;
            end

            % Calculate pz
            pz = pz_sign * sqrt(1 - px^2 - py^2);

            polar_angle = acos(pz / sqrt(px^2 + py^2 + pz^2));
            polar_angle_degrees = rad2deg(polar_angle);
            cosine_polar_angle = cos(deg2rad(polar_angle_degrees));

            weights = cosine_polar_angle;
        end

    end
end