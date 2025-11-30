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

%% H_infty-norm
C1=[1 0];
C2=[0 1];

Acl=A+B*K;

sys1ss=ss(Acl,Bf,C1,0);
% sys1tf=tf(sys1ss);
[ninf1,fpeak1]=hinfnorm(sys1ss)

sys2ss=ss(Acl,Bf,C2,0);
% sys2tf=tf(sys2ss);
[ninf2,fpeak2]=hinfnorm(sys2ss)

sys3ss=ss(Acl,Bf,eye(2),0);
% sys3tf=tf(sys3ss);
[ninf3,fpeak3]=hinfnorm(sys3ss)
