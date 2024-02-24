function [y, v, q, q_values] = flow(y_values, D, S, k, vc, g, Q)
%flow - Bisección modificado para iteración óptima.
%
% Determinar el caudal, calado y velocidad de iteración mediante el método 
% de la bisección modificado.
%
%   Argumentos de entrada:
%       y_values: Valores del calado sobre el cual se obtendrá el caudal.
%       D: Diámetro de la tubería.
%       S: Pendiente longitudinal de la alcantarilla.
%       k: Rugosidad absoluta del material de la tubería. 
%          Hace referencia al diámetro interno de la alcantarilla,
%          aquel que está en contacto con el fluido.
%       vc: Velocidad cinemática del fluido.
%       g: Gravedad.
%       Q: Caudal de diseño.
%
%   Argumentos de salida:
%       q: Caudal calculado más cercano al caudal de diseño.
%       q_values: Caudales calculados correspondientes a cada calado,
%       y_values.
%       y: Calado correspondiente al caudal calculado más cercano al caudal
%       de diseño, q.
%       v: Velocidad correspondiente al caudal calculado más cercano al
%       caudal de diseño, q.

[Am, ~, ~, ~, Dh] = geometric(y_values, D);
v_values = zeros(size(y_values));
q_values = zeros(size(y_values));

for i = 1:length(q_values)
    [v, ~, ~] = colebrook_white(D, Dh(i), S, k, vc, g);
    v_values(i) = v;
    q_values(i) = Am(i) * v;
end

[~, idx_q] = min(abs(Q - q_values));
y = y_values(idx_q);
v = v_values(idx_q);
q = q_values(idx_q);

end