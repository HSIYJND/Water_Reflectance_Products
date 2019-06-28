
%% Make full data matrix
full = [relative_time_vec Tilt_table ES_table LS_table];

time_range = 1;
tilt_range = 2:3;
ES_range = 4:size(ES_table,2)+4-1;
LS_range = size(ES_table,2)+4:size(full,2);

num_bands = size(ES_table,2);

%% Remove NaN and bad tilt
% Removing all NaN Values and undesirable tilt angles.

good_indicies = 1:size(LS_table,1); % data samples to be kept
bad_indicies = []; % data samples to be rejected

for ii = 1:size(LS_table,1)
    
    % remove NaN
    if isnan(LS_table(ii,1))
        bad_indicies = [bad_indicies ii];
    elseif isnan(ES_table(ii,1))
        bad_indicies = [bad_indicies ii];
    elseif isnan(Tilt_table(ii,1))
        bad_indicies = [bad_indicies ii];
        
        
        % remove bad tilt angles
    elseif abs(Tilt_table(ii,tilt_id)) > tilt_accept
        bad_indicies = [bad_indicies ii];
    end
end

good_indicies = setdiff(good_indicies, bad_indicies);
full_corrected = full(good_indicies, :);

%% Remove outliers
% values outside of percentile prc_values(1) and prc_values(2)

ES_cutoff = zeros(2, size(LS_table,2));
LS_cutoff = zeros(2, size(LS_table,2));

for ii = 1:size(LS_table,2)
    
    %Calculate percentiles according to prc_values(1), prc_values(2)
    ES_cutoff(:,ii) = prctile(full_corrected(:,ii+ES_range(1)-1),prc_values);
    LS_cutoff(:,ii) = prctile(full_corrected(:,ii+LS_range(1)-1),prc_values);
end

good_indicies = 1:size(full_corrected,1);
bad_indicies = [];

for ii = 1:size(full_corrected,1)
    
    % Remove too low values
    if 0 < sum(full_corrected(ii,ES_range) < ES_cutoff(1,:))
        bad_indicies = [bad_indicies ii];
    elseif 0 < sum(full_corrected(ii,LS_range) < LS_cutoff(1,:))
        bad_indicies = [bad_indicies ii];
        
        % Remove too high values
    elseif 0 < sum(full_corrected(ii,ES_range) > ES_cutoff(2,:))
        bad_indicies = [bad_indicies ii];
    elseif 0 < sum(full_corrected(ii,LS_range) > LS_cutoff(2,:))
        bad_indicies = [bad_indicies ii];
    end
end

good_indicies = setdiff(good_indicies, bad_indicies);
full_trimmed = full_corrected(good_indicies, :);