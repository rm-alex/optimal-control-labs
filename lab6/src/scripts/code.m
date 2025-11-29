%% plant parameters
A=[7 -4;
    5 6];
B=[5;
    2];
Bf=[3;
    9];
Q=[3 0;
    0 4];

%% solve Riccati
g=5.6061;
P=are(A,B*B'-g^(-2)*Bf*Bf',Q)
K=-B'*P
eP=eig(P)
eK=eig(A+B*K)
