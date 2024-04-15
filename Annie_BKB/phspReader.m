% Define the file paths for the .header and .phsp files
headerFilePath = 'phasespace_mybox.header';
phspFilePath = 'phasespace_mybox.phsp';

% Read the .header file to get column names
headerFile = fopen(headerFilePath, 'r');
columnNames = cell(10, 1);  % Initialize cell array to store column names
readingColumns = false;
line = fgetl(headerFile);
i = 1;

while ischar(line)
    if readingColumns
        if contains(line, ':')
            columnInfo = strsplit(line, ':');
            if numel(columnInfo) == 2
                columnNames{i} = strtrim(columnInfo{2});
                i = i + 1;
            end
        else
            break;  % Stop reading after column names
        end
    elseif contains(line, 'Columns of data are as follows:')
        readingColumns = true;
    end
    line = fgetl(headerFile);
end

fclose(headerFile);

% Read the .phsp file to get column data
phspFile = fopen(phspFilePath, 'r');
columnData = cell(10, 1);  % Initialize cell array to store column data

i = 1;
while ischar(line)
    values = str2double(strsplit(line));
    if numel(values) >= 10
        columnData{i} = values;
        i = i + 1;
    end
    line = fgetl(phspFile);
end

fclose(phspFile);

for ind = 1:length(columnData)
    tableData(ind,1:10) = columnData{ind,1}(2:11);

end

%%