function [v, Re, f] = colebrook_white(D, Dh, S, k, vc, g)
%colebrook_white - Ecuación de Colebrook-White para 'f', 'v' y 'Re'.
%
% Determinar el factor de fricción 'f', la velocidad 'v' y 
% el número de Reynolds 'Re'.
%
%   Argumentos de entrada:
%       D: Diámetro de la tubería
%       Dh: Diámetro hidráulico
%       S: Pendiente longitudinal de la alcantarilla
%       k: Rugosidad absoluta del material de la tubería. 
%          Hace referencia al diámetro interno de la alcantarilla,
%          aquel que está en contacto con el fluido.
%       vc: Velocidad cinemática del fluido
%       g: Gravedad
%
%   Argumentos de salida:
%       v: Velocidad del fluido
%       Re: Número de Reynolds
%       f: Factor de fricción

f_values = linspace(.01, 1);
v = @(f) sqrt(2 * g * Dh * S ./ f);
Re = @(f) v(f) .* Dh / vc;
fnc = @(f) 1 ./ sqrt(f) + 2 * log10((k / D) / 3.7 + 2.51 ./ (Re(f) .* sqrt(f)));

fnc_values = fnc(f_values);
fnc_values(fnc_values < 0) = [];
[~, fnc_min_idx] = min(fnc_values);

f0 = f_values(fnc_min_idx);
f = fzero(fnc, f0);
v = v(f);
Re = Re(f);

end