function [y, v, q, Fr, Am, Pm, Rh, T, Dh] = main_pipeline_design(D, S, Q, k)
%main_pipeline_design - Diseño de tubería.
%
% Diseñar la tubería de alcantarillado.
%
%   Argumentos de entrada:
%       D: Diámetro de la tubería.
%       S: Pendiente longitudinal de la alcantarilla.
%       Q: Caudal de diseño.
%       k: Rugosidad absoluta del material de la tubería.
%          Hace referencia al diámetro interno de la alcantarilla, aquel
%          que está en contacto con el fluido.
%
%   Argumentos de salida:
%       y: Calado.
%       v: Velocidad.
%       q: Caudal calculado.
%       Fr: Número de Froude.
%       Am: Área mojada.
%       Pm: Perímetro mojado.
%       Rh: Radio hidráulico.
%       T: Espejo de agua o longitud característica.
%       Dh: Diámetro hidráulico.

%% Constantes
yD = 0.70;
vc = 1.5e-6;
g = 9.81;
i_max = 100;

%% Conversión de unidades
D = D / 1000;           % [mm] a [m]
S = S / 100;            % [%] a [m/m]
k = k / 1000;           % [mm] a [m]
Q = Q / 1000;           % [L/s] a [m3/s]

%% Verificación de unidades
y_max = yD * D;

[Am, ~, ~, ~, Dh] = geometric(y_max, D);
v = colebrook_white(D, Dh, S, k, vc, g);
q_max = Am * v;

msg = "La tubería actual no cumple las solicitaciones. Revisar los datos de entrada." + ...
    "\n\nRecomendación: Aumentar el diámetro de la tubería.";
if Q > q_max; error(msg, class(0)); end

%% Diseño
y_values = linspace(.001, y_max, 3);
[y, v, q, q_values] = flow(y_values, D, S, k, vc, g, Q);

i = 2;
while (abs(Q - q) > 1e-5) && (i < i_max)
    idx_lower = find(q_values < Q, 1, "last");
    idx_upper = find(q_values > Q, 1, "first");
    y_lower = y_values(idx_lower);
    y_upper = y_values(idx_upper);

    y_values = linspace(y_lower, y_upper, 3);
    [y, v, q, q_values] = flow(y_values, D, S, k, vc, g, Q);

    i = i + 1;
end

%% Resultados finales
[Am, Pm, Rh, T, Dh] = geometric(y, D);
Fr = v / sqrt(g * Am ./ T);

end