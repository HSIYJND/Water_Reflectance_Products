%% Whitecap check between 750nm and 800nm

[~, rrs_750_id] = min(abs(LS_label-750));

mean_NIR = mean(LS_median(rrs_750_id:end));
var_NIR = var(LS_median(rrs_750_id:end));

Result_text = Result_text+sprintf("WHITECAPS/NIR VALUES\n");
Result_text = Result_text+...
    sprintf("Mean of Lw median from 750 to 800:      %.3d \n", mean_NIR);
Result_text = Result_text+...
    sprintf("Variance of Lw median from 750 to 800:  %.3d \n\n\n", var_NIR);
