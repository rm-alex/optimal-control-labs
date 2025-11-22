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