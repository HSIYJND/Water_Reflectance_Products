%% QAA With Median Rrs Estimates
% As shown in:
%     "Deriving inherent optical properties from water color:
%     a multiband quasi-analytical algorithm for optically deep waters"
%     Lee et. al., 2002
% 
% All coefficients are taken from the paper
% Most functions work on both scalar and vectors
% Assumes Rrs_median exists

% Convert from above- to below-surface remote sensing reflectance
%   rrs(lambda) -> Rrs2rrs(Rrs_lambda)
Rrs2rrs = @(Rrs_lambda)...
    Rrs_lambda/(0.52 + 1.7*Rrs_lambda);

rrs_median = Rrs_median;
for R2r_id = 1:length(rrs_median)
    rrs_median(R2r_id) = Rrs2rrs(Rrs_median(R2r_id));
end

% Calculate u(lambda) 
%   u(lambda) -> u_lambda(rrs_lambda)
% g0 = 0.08945; g1 = 0.1247;
u_lambda = @(rrs_lambda)...
    (-0.08945 + sqrt(0.08945^2 + 4*0.1247*rrs_lambda))/(2*0.1247);

% Compute a(555), total absorption at lambda 555 nm 
[~, rrs_410_id] = min(abs(Rrs_label-410)); rrs_410 = rrs_median(rrs_410_id);
[~, rrs_440_id] = min(abs(Rrs_label-440)); rrs_440 = rrs_median(rrs_440_id);
[~, rrs_510_id] = min(abs(Rrs_label-510)); rrs_510 = rrs_median(rrs_510_id);
[~, rrs_555_id] = min(abs(Rrs_label-555)); rrs_555 = rrs_median(rrs_555_id);
[~, rrs_670_id] = min(abs(Rrs_label-440)); rrs_670 = rrs_median(rrs_670_id);

[~, Rrs_440_id] = min(abs(Rrs_label-440)); Rrs_440 = Rrs_median(Rrs_440_id);
[~, Rrs_490_id] = min(abs(Rrs_label-490)); Rrs_490 = Rrs_median(Rrs_490_id);
[~, Rrs_555_id] = min(abs(Rrs_label-555)); Rrs_555 = Rrs_median(Rrs_555_id);
[~, Rrs_640_id] = min(abs(Rrs_label-640)); Rrs_640 = Rrs_median(Rrs_640_id);
[~, Rrs_640_id] = min(abs(Rrs_label-640)); Rrs_640 = Rrs_median(Rrs_640_id);

rho = log10((Rrs_440+Rrs_490)/(Rrs_555+2*(Rrs_640/Rrs_490)*Rrs_640));
a_temp = 10^(-1.22552660524304...
             -1.21431091727277*rho...
             -0.350055220063551*rho^2);
a_555 = 0.0595 + a_temp;


% Compute b_bp(555), 
%   backscattering coefficient of suspended particles at 555nm
u_555 = u_lambda(rrs_555);
b_bp_555 = (u_555*a_555)/(1-u_555) - b_bw_lambda(555);

% Compute Y, spectral power for particle backscattering coefficient
Y = 2.2*(1 - 1.2*exp( -0.9*( rrs_440/rrs_555 )));

% Calculate b_bp(lambda), 
%   backscattering coefficient of suspended particles at lambda
%
%   b_bp(lambda) -> b_bp_lambda(lambda)
b_bp_lambda = @(lambda)...
    b_bp_555*(555/lambda)^Y;

% Calculate a(lambda), total absorption at lambda lambda nm 
%   a(lambda) -> a_lambda(rrs_lambda, lambda)
a_lambda = @(rrs_lambda,lambda)...
    (1-u_lambda(rrs_lambda)) * ...
    ( b_bp_lambda(lambda)+ b_bw_lambda(lambda)) /...
    (u_lambda(rrs_lambda));

zeta = 0.71 + (0.06)/(0.8 + (rrs_440/rrs_555));
xi = exp(xi_Slope*(440-410));

% Compute a_g_440, absorption coefficient of gelbstoff and detrius at 440nm
a_g_440 = ... 
    (a_lambda(rrs_410,410) - zeta*a_lambda(rrs_440,440))/(xi-zeta)...
    -(a_w_410 - zeta*a_w_440)/(xi-zeta);

% Compute a_phi_440, absorption coefficient of phytoplankton pigments at 440nm
a_phi_440 = a_lambda(rrs_440,440) - a_g_440 - a_w_440;
    

Result_text = Result_text+sprintf("INHERENT OPTICAL PROPERTIES\n");
Result_text = Result_text+sprintf("Using QAA from 2002-Lee et. al.\n");
Result_text = Result_text+sprintf("Assuming xi = exp(%.3f * (440-410)) \n\n",xi_Slope);

Result_text = Result_text+sprintf("a(410),total absorption at 410 nm :    %.3f \n", a_lambda(rrs_410,410));
Result_text = Result_text+sprintf("a(440),total absorption at 440 nm :    %.3f \n", a_lambda(rrs_440,440));
Result_text = Result_text+sprintf("a(510),total absorption at 510 nm :    %.3f \n", a_lambda(rrs_510,510));
Result_text = Result_text+sprintf("a(555),total absorption at 555 nm :    %.3f \n", a_lambda(rrs_555,555));
Result_text = Result_text+sprintf("a(670),total absorption at 670 nm :    %.3f \n", a_lambda(rrs_670,670));

Result_text = Result_text+sprintf("a(555),total absorption at 555 nm :    %.3f \n", a_555);
Result_text = Result_text+sprintf("Y, spectral power:                     %.3f \n\n", Y);

Result_text = Result_text+sprintf("a_g(440), absorption coefficient of gelbstoff and detrius at 440nm    %.3f \n", a_g_440);
Result_text = Result_text+sprintf("a_phi(440), absorption coefficient of phytoplankton pigments at 440nm %.3f \n", a_phi_440);