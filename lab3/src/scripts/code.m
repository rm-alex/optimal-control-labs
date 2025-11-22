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