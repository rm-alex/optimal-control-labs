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
[ninf1,fpeak1]=hinfnorm(sys1ss)

sys2ss=ss(Acl,Bf,C2,0);
[ninf2,fpeak2]=hinfnorm(sys2ss)

sys3ss=ss(Acl,Bf,eye(2),0);
[ninf3,fpeak3]=hinfnorm(sys3ss)

%% defense
syms s w real

W_s = simplify(eye(2)*inv(s*eye(size(Acl))-Acl)*Bf);
W_jw = subs(W_s, s, 1i*w)
W_jw_e = transpose(subs(W_s, s, -1i*w));

GG = W_jw_e * W_jw;
sing_vals = simplify(sqrt(eig(GG)))

omega_vals = logspace(-2, 3, 1000);
sigma_values = zeros(length(omega_vals), 1);

for i = 1:length(omega_vals)
    sigma_num = double(subs(sing_vals, w, omega_vals(i)));
    sigma_values(i) = max(real(sigma_num));
end