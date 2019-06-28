%% OC4 -> Chlor-a Median Estimates
Result_text = Result_text+sprintf("BLUE-GREEN BAND RATIO ALGORITHM\n");
Result_text = Result_text+sprintf(...
    "OC4 value with median Rrs post filtering \n");
Result_text = Result_text+sprintf("Using  coefficients for SeaWiFS \n");

[~, green_id]     = min(abs(Rrs_label-555));
[~, blue1_id]     = min(abs(Rrs_label-443));
[~, blue2_id]     = min(abs(Rrs_label-490));
[~, blue3_id]     = min(abs(Rrs_label-510));

green_nm = Rrs_label(green_id);
blue1_nm = Rrs_label(blue1_id);
blue2_nm = Rrs_label(blue2_id);
blue3_nm = Rrs_label(blue3_id);

ax = [0.3272, -2.9940, 2.7218, -1.2259, -0.5683];
chlor_a = ax(1);

Rrs_green = Rrs_median(green_id);
Rrs_blue = max([...
    Rrs_median(blue1_id),...
    Rrs_median(blue2_id),...
    Rrs_median(blue3_id)]);

for i = 2:length(ax)
    chlor_a = chlor_a + ax(i)*(log10(Rrs_blue/Rrs_green))^i;
end

chlor_a = 10^(chlor_a);


Result_text = Result_text+sprintf("BANDS\n");
Result_text = Result_text+sprintf("    Green:    %.2fnm \n", green_nm);
Result_text = Result_text+sprintf("    Blue1:    %.2fnm \n", blue1_nm);
Result_text = Result_text+sprintf("    Blue2:    %.2fnm \n", blue2_nm);
Result_text = Result_text+sprintf("    Blue3:    %.2fnm \n\n", blue3_nm);

Result_text = Result_text+...
    sprintf("chlorphyll estimate:       %.2f mg/m^(-3)\n\n\n", chlor_a);