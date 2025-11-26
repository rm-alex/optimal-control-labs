%% Criteria and grad
J = @(x, u) 4*x.^2 + 3*u.^2 + 6*x.*u + 9*x + 2*u - 7;
gradJ = @(x, u) [8*x + 6*u + 9; ...
                 6*x + 6*u + 2];

max_iter = 500;
tol = 1e-8;
x0 = 0; u0 = 0;

%% Aperiodic: g = 0.05
gamma_ap = 0.05;

x_hist_ap = zeros(max_iter+1, 1);
u_hist_ap = zeros(max_iter+1, 1);
J_hist_ap = zeros(max_iter+1, 1);
grad_hist_ap = zeros(2, max_iter+1);

x = x0; u = u0;
x_hist_ap(1) = x;
u_hist_ap(1) = u;
J_hist_ap(1) = J(x, u);
grad_hist_ap(:, 1) = gradJ(x, u);

n_ap = 1;

for k = 1:max_iter
    g = grad_hist_ap(:, n_ap);
    
    if norm(g) < tol
        break;
    end
    
    x = x - gamma_ap * g(1);
    u = u - gamma_ap * g(2);
    
    n_ap = n_ap + 1;
    x_hist_ap(n_ap) = x;
    u_hist_ap(n_ap) = u;
    J_hist_ap(n_ap) = J(x, u);
    grad_hist_ap(:, n_ap) = gradJ(x, u);
end

x_hist_ap = x_hist_ap(1:n_ap);
u_hist_ap = u_hist_ap(1:n_ap);
J_hist_ap = J_hist_ap(1:n_ap);
grad_hist_ap = grad_hist_ap(:, 1:n_ap);


%% Oscillating: g = 0.12
gamma_os = 0.12;

x_hist_os = zeros(max_iter+1, 1);
u_hist_os = zeros(max_iter+1, 1);
J_hist_os = zeros(max_iter+1, 1);
grad_hist_os = zeros(2, max_iter+1);

x = x0; u = u0;
x_hist_os(1) = x;
u_hist_os(1) = u;
J_hist_os(1) = J(x, u);
grad_hist_os(:, 1) = gradJ(x, u);

n_os = 1;

for k = 1:max_iter
    g = grad_hist_os(:, n_os);
    
    if norm(g) < tol
        break;
    end
    
    x = x - gamma_os * g(1);
    u = u - gamma_os * g(2);
    
    n_os = n_os + 1;
    x_hist_os(n_os) = x;
    u_hist_os(n_os) = u;
    J_hist_os(n_os) = J(x, u);
    grad_hist_os(:, n_os) = gradJ(x, u);
end

x_hist_os = x_hist_os(1:n_os);
u_hist_os = u_hist_os(1:n_os);
J_hist_os = J_hist_os(1:n_os);
grad_hist_os = grad_hist_os(:, 1:n_os);
