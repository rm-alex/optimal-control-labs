%% plant parameters
A=[0 1;
    -2 4];
b=[8;
    9];
Q=[3 0;
    0 4];
r=4;
v = 1;

%% solve Riccati
[P,K,e]=icare(A,sqrt(v)*b,Q,r);
P
K=inv(r)*b'*P
eK=eig(A-b*K)

%% J approx
x0 = [1; 0];
sys_cl = ss(A - b*K, [], [], []);
t = 0:0.001:5;
[y, t, x] = initial(sys_cl, x0, t);

J_num = 0;
for i = 1:length(t)-1
    dt = t(i+1) - t(i);
    xi = x(i,:)';
    ui = -K * xi;
    integrand = xi' * Q * xi + r * (ui^2);
    J_num = J_num + integrand * dt;
end

%% (2)
K_b=1.05*K
eK_b=eig(A-b*K_b)

%% (3)
r1=1;
r2=4;
r3=10;

k1=0.5;
k2=1;
k3=2;

Q1=k1*Q;
Q2=k2*Q;
Q3=k3*Q;

% 1,i
[P11,~,e11]=icare(A,sqrt(v)*b,Q1,r1);
[P12,~,e12]=icare(A,sqrt(v)*b,Q1,r2);
[P13,~,e13]=icare(A,sqrt(v)*b,Q1,r3);

K11=inv(r1)*b'*P11
K12=inv(r2)*b'*P12
K13=inv(r3)*b'*P13

% 2,i
[P21,~,e21]=icare(A,sqrt(v)*b,Q2,r1);
[P22,~,e22]=icare(A,sqrt(v)*b,Q2,r2);
[P23,~,e23]=icare(A,sqrt(v)*b,Q2,r3);

K21=inv(r1)*b'*P21
K22=inv(r2)*b'*P22
K23=inv(r3)*b'*P23

% 3,i
[P31,~,e31]=icare(A,sqrt(v)*b,Q3,r1);
[P32,~,e32]=icare(A,sqrt(v)*b,Q3,r2);
[P33,~,e33]=icare(A,sqrt(v)*b,Q3,r3);

K31=inv(r1)*b'*P31
K32=inv(r2)*b'*P32
K33=inv(r3)*b'*P33

%% (4)
r_vals = [r1, r2, r3];
k_vals = [k1, k2, k3];

simOut = sim('sim3');

%% X
x11 = simOut.get('x11');
x12 = simOut.get('x12');
x13 = simOut.get('x13');

x21 = simOut.get('x21');
x22 = simOut.get('x22');
x23 = simOut.get('x23');

x31 = simOut.get('x31');
x32 = simOut.get('x32');
x33 = simOut.get('x33');

X = { {x11, x12, x13}, ...
      {x21, x22, x23}, ...
      {x31, x32, x33} };

for j = 1:3
    figure('Name', sprintf('Q_%d', j), 'NumberTitle', 'off');

    % ---- x1(t) ----
    subplot(2,1,1); hold on; grid on;
    for i = 1:3
        plot(X{j}{i}.time, X{j}{i}.signals.values(:,1), 'LineWidth', 1.5);
    end
    xlabel('t, s'); ylabel('x_1');
    title(sprintf('State x_1 for Q_%d', j));
    legend(arrayfun(@(r) sprintf('r = %d', r), r_vals, 'UniformOutput', false));

    % ---- x2(t) ----
    subplot(2,1,2); hold on; grid on;
    for i = 1:3
        plot(X{j}{i}.time, X{j}{i}.signals.values(:,2), 'LineWidth', 1.5);
    end
    xlabel('t, s'); ylabel('x_2');
    title(sprintf('State x_2 for Q_%d', j));
    legend(arrayfun(@(r) sprintf('r = %d', r), r_vals, 'UniformOutput', false));
end

%% u
u11 = simOut.get('u11');
u12 = simOut.get('u12');
u13 = simOut.get('u13');

u21 = simOut.get('u21');
u22 = simOut.get('u22');
u23 = simOut.get('u23');

u31 = simOut.get('u31');
u32 = simOut.get('u32');
u33 = simOut.get('u33');

U = { {u11, u12, u13}, ...
      {u21, u22, u23}, ...
      {u31, u32, u33} };

for j = 1:3
    figure('Name', sprintf('Control Q_%d', j), 'NumberTitle', 'off');
    hold on; grid on;

    for i = 1:3
        plot(U{j}{i}.time, U{j}{i}.signals.values, 'LineWidth', 1.5);
    end
    
    xlabel('t, s');
    ylabel('u(t)');
    title(sprintf('Control for Q_%d', j));
    
    legend(arrayfun(@(r) sprintf('r = %d', r), r_vals, ...
        'UniformOutput', false), 'Location', 'best');
end

%% J
J11 = simOut.get('J11');
J12 = simOut.get('J12');
J13 = simOut.get('J13');

J21 = simOut.get('J21');
J22 = simOut.get('J22');
J23 = simOut.get('J23');

J31 = simOut.get('J31');
J32 = simOut.get('J32');
J33 = simOut.get('J33');

J = { {J11, J12, J13}, ...
      {J21, J22, J23}, ...
      {J31, J32, J33} };

for j = 1:3
    figure('Name', sprintf('Cost Q_%d', j), 'NumberTitle', 'off');
    hold on; grid on;

    for i = 1:3
        plot(J{j}{i}.time, J{j}{i}.signals.values, 'LineWidth', 1.5);
    end
    
    xlabel('t, s');
    ylabel('J(t)');
    title(sprintf('Quality criteria for Q_%d', j));
    
    legend(arrayfun(@(r) sprintf('r = %d', r), r_vals, ...
        'UniformOutput', false), 'Location', 'best');
end
