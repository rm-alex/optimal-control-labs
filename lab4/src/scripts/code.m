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

%% (2)
K_b=1.1*K
eK_b=eig(A-b*K_b)

%% defense
% if v=[x;Px] then d/dt[x;Px]=H[x;Px]
H=[A -b*inv(r)*b';
    -Q -A'];
[V,D] = eig(H);

n = size(A,1);

cols = 1:4; 
comb = nchoosek(cols,n);
allP = cell(size(comb,1),1);

for i = 1:size(comb,1)
    idx = comb(i,:);
    Vs = V(:, idx);
    Xs = Vs(1:n,:);
    Ys = Vs(n+1:end,:);
    
    if rank(Xs)==n
        P = Ys / Xs;
        allP{i} = P;
    else
        allP{i} = [];
    end
end

for i = 1:length(allP)
    if ~isempty(allP{i})
        K = inv(r)*b' * allP{i}
        disp('Closed-loop eigenvalues:');
        disp(eig(A-b*K));
    end
end


