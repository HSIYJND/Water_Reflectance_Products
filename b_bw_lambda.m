function [b_bw_lambda_value] = b_bw_lambda(lambda, scattering_values)
% Calculate b_bp(lambda), backscattering coefficient
% of suspended particles at lambda
% pass a new matrix of scattering values to change properties
% scattering_values = Matrix(wavelength_column, scattering_values_column

% c1 wavlength nm, c2 scattering value

if nargin == 1
    scattering_values = ...
        [200, 0.151;
        210, 0.119;
        220, 0.0995;
        230, 0.0820;
        240, 0.0685;
        250, 0.0575;
        260, 0.0485;
        270, 0.0415;
        280, 0.0353;
        290, 0.0305;
        300, 0.0262;
        310, 0.0229;
        320, 0.0200;
        330, 0.0175;
        340, 0.0153;
        350, 0.0134;
        360, 0.0120;
        370, 0.0106;
        380, 0.0094;
        390, 0.0084;
        400, 0.0076;
        410, 0.0068;
        420, 0.0061;
        430, 0.0055;
        440, 0.0049;
        450, 0.0045;
        460, 0.0041;
        470, 0.0037;
        480, 0.0034;
        490, 0.0031;
        500, 0.0029;
        510, 0.0026;
        520, 0.0024;
        530, 0.0022;
        540, 0.0021;
        550, 0.0019;
        560, 0.0018;
        570, 0.0017;
        580, 0.0016;
        590, 0.0015;
        600, 0.0014;
        610, 0.0013;
        620, 0.0012;
        630, 0.0011;
        640, 0.0010;
        650, 0.0010;
        660, 0.0008;
        670, 0.0008;
        680, 0.0007;
        690, 0.0007;
        700, 0.0007;
        710, 0.0007;
        720, 0.0006;
        730, 0.0006;
        740, 0.0006;
        750, 0.0005;
        760, 0.0005;
        770, 0.0005;
        780, 0.0004;
        790, 0.0004;
        800, 0.0004;];
end

pp = spline(scattering_values(:,1), scattering_values(:,2));

% Division by 2 to go from scattering to backscattering
b_bw_lambda_value = ppval(pp,lambda)/2;

end