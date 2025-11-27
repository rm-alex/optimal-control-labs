clear; clc; close all;

omega = 2.8284;

t = linspace(0, 3, 1000);

% coef = 0.5;
% phi1 = 43.446 * sin(omega*t) - 26.645 * cos(omega*t);
% phi2 = 15.360 * cos(omega*t) + 9.4202 * sin(omega*t);

% coef = 0.05;
% phi1 = 434.50 * sin(omega*t) - 266.41 * cos(omega*t);
% phi2 = 153.62 * cos(omega*t) + 94.190 * sin(omega*t);

% coef = 0.1;
% phi1 = 217.25 * sin(omega*t) - 133.21 * cos(omega*t);
% phi2 = 76.808 * cos(omega*t) + 47.098 * sin(omega*t);

% coef = 0.25;
% phi1 = 86.899 * sin(omega*t) - 53.283 * cos(omega*t);
% phi2 = 30.722 * cos(omega*t) + 18.838 * sin(omega*t);

% coef = 0.75;
% phi1 = 28.966 * sin(omega*t) - 17.762 * cos(omega*t);
% phi2 = 10.241 * cos(omega*t) + 6.2798 * sin(omega*t);

coef = 1;
phi1 = 21.725 * sin(omega*t) - 13.321 * cos(omega*t);
phi2 = 7.6808 * cos(omega*t) + 4.7098 * sin(omega*t);

u = coef * phi2;

% 0.05, 0.1, 0.25, 0.5
x1 = 1.3578 * t .* sin(omega*t) ...
         - 0.83254 * t .* cos(omega*t) ...
         + 0.29434 * sin(omega*t);

x2 = 3.8405 * t .* cos(omega*t) ...
         + 2.3548 * t .* sin(omega*t) ...
         + 1.3578 * sin(omega*t);

J = cumtrapz(t, u.^2);

figure('Position',[100,100,1200,800]);

subplot(2,2,1);
plot(t, x1, 'b-', 'LineWidth', 1.8); hold on;
plot(t, x2, 'r--', 'LineWidth', 1.8);
yline(5, '--k', 'LineWidth', 1.2);
yline(0, ':k', 'LineWidth', 1.2);

plot(3, x1(end), 'bo', 'MarkerSize', 8, 'MarkerFaceColor','b');
plot(3, x2(end), 'ro', 'MarkerSize', 8, 'MarkerFaceColor','r');
xlabel('t'); ylabel('x_1(t), x_2(t)');
title('Состояния x_1(t) и x_2(t)');
legend('x_1(t)', 'x_2(t)', 'x_1=5', 'x_2=0', 'Location','best');
grid on;

subplot(2,2,2);
plot(t, u, 'm-', 'LineWidth', 2);
xlabel('t'); ylabel('u(t)');
title(['Оптимальное управление u(t) = ', num2str(coef), '\phi_2(t)']);
grid on;

subplot(2,2,3);
plot(t, J, 'k-', 'LineWidth', 2);
xlabel('t'); ylabel('J(t) = \int_0^t u^2 d\tau');
title(['Критерий качества J(t),  J(3) = ', num2str(J(end), '%.6f')]);
grid on;

subplot(2,2,4);
plot(x1, x2, 'g-', 'LineWidth', 1.8); hold on;
plot(x1(1), x2(1), 'go', 'MarkerFaceColor','g', 'MarkerSize',8);
plot(x1(end), x2(end), 'ro', 'MarkerFaceColor','r', 'MarkerSize',8);
text(x1(1), x2(1), '  (0,0)', 'FontSize',10, 'VerticalAlignment','bottom');
text(x1(end), x2(end), sprintf('  (5,0)\n  t=%.1f', t(end)), ...
      'FontSize',10, 'VerticalAlignment','bottom');
xlabel('x_1'); ylabel('x_2');
title('Фазовая траектория');
grid on; axis equal;

sgtitle('Оптимальное управление по решению Maple', ...
        'FontSize',14, 'FontWeight','bold');

fprintf('Конечные значения:\n');
fprintf('x1(3) = %.6f (должно быть 5)\n', x1(end));
fprintf('x2(3) = %.6f (должно быть 0)\n', x2(end));
fprintf('u(3) = %.6f\n', u(end));
fprintf('J(3) = %.6f\n', J(end));