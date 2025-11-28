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

%% Riccati
GWGT=G*W*G';
[P,L,e]=icare(A',C',GWGT,V);
P
L=P*C'*V^-1
e=eig(A-L*C)

%% sim 1 params

set_param('sim1/A', 'Gain', mat2str(A));
set_param('sim1/A1', 'Gain', mat2str(A));
set_param('sim1/b', 'Gain', mat2str(b));
set_param('sim1/b1', 'Gain', mat2str(b));
set_param('sim1/C', 'Gain', mat2str(C));
set_param('sim1/C1', 'Gain', mat2str(C));
set_param('sim1/L', 'Gain', mat2str(L));

%% sim 1
simOut = sim('sim1');