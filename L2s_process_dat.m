% load data with tab delimiter into workspace
data = importfile_dat(join([path file]));

% get indicies of data tables
% each block starts with a "Datetag"
indicies = [];
for ii = 1:size(data(:,1),1)
    if string(data(ii,1).Variables) == "Datetag"
        indicies = [indicies ii];
    end
end

%% Get data into matrix
start_date = categories(data(indicies(1)+1,1).Variables);
start_date = str2num(start_date{1});

start_time = categories(data(indicies(1)+1, 2).Variables);
start_time = start_time{1};

% convert to seconds from start
% (will break if done at midnight)
time_hh_mm_ss = [strsplit(start_time,':')];

origin_time = str2num(time_hh_mm_ss{1})*3600 + ...
    str2num(time_hh_mm_ss{2})*60 + ...
    str2num(time_hh_mm_ss{3});

absolute_time_vec = data(indicies(1)+1:(indicies(2)-2), 2);
absolute_time_vec = absolute_time_vec.Variables;

relative_time_vec = zeros(size(absolute_time_vec,1),1);
for ii = 1:length(relative_time_vec)
    
    % get absolute time
    absTime = string(absolute_time_vec(ii));
    absTime = [strsplit(absTime,':')];
    
    % get relative time
    relative_time_vec(ii) = str2num(absTime{1})*3600 + ...
        str2num(absTime{2})*60 + ...
        str2num(absTime{3}) - ...
        origin_time;
end

% get ES
ES_label = data(indicies(1), 3:end);
ES_label = ES_label.Variables;

ES_table = data(indicies(1)+1:(indicies(2)-2), 3:end);
ES_table = ES_table.Variables;

% get LS
LS_label = data(indicies(2), 3:end);
LS_label = LS_label.Variables;

LS_table = data(indicies(2)+1:(indicies(3)-2), 3:end);
LS_table = LS_table.Variables;

% get Tilt
Tilt_label = ["tilt_1", "tilt_2"];

Tilt_table = data(indicies(3)+1:end, [3, 6]);
Tilt_table = Tilt_table.Variables;