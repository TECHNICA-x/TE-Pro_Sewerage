function [Am, Pm, Rh, T, Dh] = geometric(y, D)
%geometric - Parámetros hidráulicos.
%
% Determinar los parámetros hidráulicos/geométricos de la tubería.
%
%   Argumentos de entrada:
%       y_values: Valores del calado sobre el cual se obtendrá el caudal.
%       D: Diámetro de la tubería.
%
%   Argumentos de salida:
%       Am: Área mojada.
%       Pm: Perímetro mojado.
%       Rh: Radio hidráulico.
%       T: Espejo de agua o longitud superficial.
%       Dh: Diámetro hidráulico.

r = D / 2;
theta = 2 * acos(1 - y / r);
Am = .5 * r ^ 2 * (theta - sin(theta));
Pm = r * theta;
Rh = Am ./ Pm;
T = sin(.5 * theta) * D;
Dh = 4 * Rh;

end