%% plant parameters
A=[0 -9;
   1 -4];
b=[5;
    0];
C=[1 0];
G=eye(2);
W=[7 5;
    5 6];
Q=[3 0;
    0 4];
V=1;
r=4;

%% W biased
W = 0.5*W;
weig=eig(W)

[~, p] = chol(W);
if p == 0
    disp('Матрица положительно определённая');
else
    disp('Матрица НЕ положительно определённая');
end

%% V biased
V=0.5*V;

%% Riccati L
GWGT=G*W*G';
[P,L,e]=icare(A',C',GWGT,V);
P
L=P*C'*V^-1
e=eig(A-L*C)

%% Riccati K
v=1;
[PK,K,e]=icare(A,sqrt(v)*b,Q,r);
PK
K=inv(r)*b'*PK
eK=eig(A-b*K)

%% L biased
L=1.2*L
e=eig(A-L*C)

%% L biased 2
L=0.8*L
e=eig(A-L*C)

%% sim 1 params

set_param('sim1/A', 'Gain', mat2str(A));
set_param('sim1/A1', 'Gain', mat2str(A));
set_param('sim1/b', 'Gain', mat2str(b));
set_param('sim1/b1', 'Gain', mat2str(b));
set_param('sim1/C', 'Gain', mat2str(C));
set_param('sim1/C1', 'Gain', mat2str(C));
set_param('sim1/L', 'Gain', mat2str(L));
set_param('sim1/G', 'Gain', mat2str(G));
set_param('sim1/W', 'Gain', mat2str(W));
set_param('sim1/V', 'Cov', mat2str(V));

%% sim 2 params
set_param('sim2/A', 'Gain', mat2str(A));
set_param('sim2/A1', 'Gain', mat2str(A));
set_param('sim2/b', 'Gain', mat2str(b));
set_param('sim2/b1', 'Gain', mat2str(b));
set_param('sim2/C', 'Gain', mat2str(C));
set_param('sim2/C1', 'Gain', mat2str(C));
set_param('sim2/L', 'Gain', mat2str(L));
set_param('sim2/G', 'Gain', mat2str(G));
set_param('sim2/W', 'Gain', mat2str(W));
set_param('sim2/V', 'Cov', mat2str(V));
set_param('sim2/K', 'Gain', mat2str(K));

%% sim 1,2
% simOut = sim('sim1');
simOut = sim('sim2');

eLx = simOut.get('eLx');
% eLy = simOut.get('eLy');
J = simOut.get('J');
% x = simOut.get('x');
% x_hat = simOut.get('x_hat');
% u = simOut.get('u');

J_vals = J.signals.values;
t_J = J.time;
J_mean = mean(J_vals, 'omitnan');

figure('Name', 'Observation Errors eLx', 'NumberTitle', 'off');
plot(eLx.time, eLx.signals.values(:,1), 'b-', 'LineWidth', 1.5);
hold on;
plot(eLx.time, eLx.signals.values(:,2), 'r-', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)', 'FontSize', 12);
ylabel('Error', 'FontSize', 12);
title('Observation Errors: eLx = x - xhat', 'FontSize', 14);
legend('eLx_1', 'eLx_2', 'Location', 'best');
set(gca, 'FontSize', 11);

figure('Name', 'Quality Criterion J', 'NumberTitle', 'off');
plot(t_J, J_vals, 'b-', 'LineWidth', 1.5);
hold on;
plot([t_J(1), t_J(end)], [J_mean, J_mean], 'r--', 'LineWidth', 1.5, ...
     'DisplayName', sprintf('mean(J) = %.4g', J_mean));
grid on;
xlabel('Time (s)', 'FontSize', 12);
ylabel('J(t)', 'FontSize', 12);
title('Quality Criterion J', 'FontSize', 14);
legend('J(t)', sprintf('M[J]=%.4f', J_mean), 'Location', 'best');
set(gca, 'FontSize', 11);