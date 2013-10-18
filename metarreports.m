function [altimeter,date_time_issued,dewpoint,is_visibility_less_than,is_wind_direction_variabl,id,original_report,remark,report_modifier,sea_level_pressure,station_type,temperature,variable_wind_direction,visibility,weather_station_code,wind_direction,wind_gusts,wind_speed] = metarreports(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [ALTIMETER,DATE_TIME_ISSUED,DEWPOINT,IS_VISIBILITY_LESS_THAN,IS_WIND_DIRECTION_VARIABL,ID,ORIGINAL_REPORT,REMARK,REPORT_MODIFIER,SEA_LEVEL_PRESSURE,STATION_TYPE,TEMPERATURE,VARIABLE_WIND_DIRECTION,VISIBILITY,WEATHER_STATION_CODE,WIND_DIRECTION,WIND_GUSTS,WIND_SPEED]
%   = IMPORTFILE(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   [ALTIMETER,DATE_TIME_ISSUED,DEWPOINT,IS_VISIBILITY_LESS_THAN,IS_WIND_DIRECTION_VARIABL,ID,ORIGINAL_REPORT,REMARK,REPORT_MODIFIER,SEA_LEVEL_PRESSURE,STATION_TYPE,TEMPERATURE,VARIABLE_WIND_DIRECTION,VISIBILITY,WEATHER_STATION_CODE,WIND_DIRECTION,WIND_GUSTS,WIND_SPEED]
%   = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%
% Example:
%   [altimeter,date_time_issued,dewpoint,is_visibility_less_than,is_wind_direction_variabl,id,original_report,remark,report_modifier,sea_level_pressure,station_type,temperature,variable_wind_direction,visibility,weather_station_code,wind_direction,wind_gusts,wind_speed]
%   = importfile('metarreports.csv',2, 2685407);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2013/09/19 22:36:48

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[3,6,10,11,12,16,18]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end

%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [3,6,10,11,12,16,18]);
rawCellColumns = raw(:, [1,2,4,5,7,8,9,13,14,15,17]);


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
altimeter = rawCellColumns(:, 1);
date_time_issued = rawCellColumns(:, 2);
dewpoint = cell2mat(rawNumericColumns(:, 1));
is_visibility_less_than = rawCellColumns(:, 3);
is_wind_direction_variabl = rawCellColumns(:, 4);
id = cell2mat(rawNumericColumns(:, 2));
original_report = rawCellColumns(:, 5);
remark = rawCellColumns(:, 6);
report_modifier = rawCellColumns(:, 7);
sea_level_pressure = cell2mat(rawNumericColumns(:, 3));
station_type = cell2mat(rawNumericColumns(:, 4));
temperature = cell2mat(rawNumericColumns(:, 5));
variable_wind_direction = rawCellColumns(:, 8);
visibility = rawCellColumns(:, 9);
weather_station_code = rawCellColumns(:, 10);
wind_direction = cell2mat(rawNumericColumns(:, 6));
wind_gusts = rawCellColumns(:, 11);
wind_speed = cell2mat(rawNumericColumns(:, 7));
