function xHat=UKF(N, Ts, m, M, g, l, P, Q, R, u, x0, xStateInit, w, v)

xState(:, 1) = xStateInit; 
xHat = zeros(4, N);
xHat(:, 1) = x0;

[f, h]=set_functions;

for k = 2:N
    xState(:,k) = xState(:,k-1)+Ts*[xState(2,k-1);(u*cos(xState(1,k-1))-(M+m)*g*sin(xState(1,k-1))+m*l*(cos(xState(1,k-1)))*(sin(xState(1,k-1)))*xState(2,k-1)*xState(2,k-1))/(m*l*(cos(xState(1,k-1)))*cos(xState(1,k-1))-(M+m)*l) ;xState(4,k-1);(u+m*l*(sin(xState(1,k-1)))*(xState(2,k-1)*xState(2,k-1))-m*g*sin(xState(1,k-1))*cos(xState(1,k-1)))/(M+m-m*cos(xState(1,k-1))*cos(xState(1,k-1)))] + w(:,k-1);
end

alpha = 0.001;       
kpa = -1; 
beta  = 2;            
n1 = size(xHat,1);
n2 = size(Q, 1);
n3 = size(R, 1);
L  = n1 + n2 + n3;
ns = 2 * L + 1;
lambda = alpha ^2 * (L + kpa) - L;
gamma = sqrt(L + lambda);
W_m_0 = lambda / (L + lambda);
W_c_0 = W_m_0 + 1 - alpha^2 + beta;
W_i = 1/(2*(L + lambda));
P_a = blkdiag(P, Q, R);

for k = 2:N
    xHat(:,k) = xHat(:,k-1)+Ts*[xHat(2,k-1);(u*cos(xHat(1,k-1))-(M+m)*g*sin(xHat(1,k-1))+m*l*(cos(xHat(1,k-1)))*(sin(xHat(1,k-1)))*xHat(2,k-1)*xHat(2,k-1))/(m*l*(cos(xHat(1,k-1)))*cos(xHat(1,k-1))-(M+m)*l) ;xHat(4,k-1) ;(u+m*l*(sin(xHat(1,k-1)))*(xHat(2,k-1)*xHat(2,k-1))-m*g*sin(xHat(1,k-1))*cos(xHat(1,k-1)))/(M+m-m*cos(xHat(1,k-1))*cos(xHat(1,k-1)))]+w(:,k-1);
    z_k = [1 , 0 , 0 , 0 ;0 , 0 , 1 , 0 ]*xHat(:,k)+v(:,k-1);
    x_a_km1 = [xHat(:,k); zeros(n2, 1); zeros(n3, 1)];
    [U, s] = svd(P_a);
    gamma_sqrt_P_a = gamma * U * sqrt(s);
    X_a_km1 = [x_a_km1, repmat(x_a_km1, 1, L) + gamma_sqrt_P_a, repmat(x_a_km1, 1, L) - gamma_sqrt_P_a];
    Z_kkm1   = zeros(n3, ns);
    X_x_kkm1 = zeros(n1, ns);
    for sp = 1:ns
        X_x_kkm1(:, sp) = X_a_km1(1:n1,sp)+ Ts*[X_a_km1(2, sp);(u*cos(X_a_km1(1,sp))-(M+m)*g*sin(X_a_km1(1,sp))+m*l*(cos(X_a_km1(1,sp)))*(sin(X_a_km1(1,sp)))*X_a_km1(2,sp)*X_a_km1(2,sp))/(m*l*(cos(X_a_km1(1,sp)))*cos(X_a_km1(1,sp))-(M+m)*l); X_a_km1(4, sp) ;(u+m*l*(sin(X_a_km1(1, sp)))*(X_a_km1(2, sp)*X_a_km1(2, sp))-m*g*sin(X_a_km1(1, sp))*cos(X_a_km1(1, sp)))/(M+m-m*cos(X_a_km1(1, sp))*cos(X_a_km1(1, sp)))];
        Z_kkm1(:, sp)   = [1 , 0 , 0 , 0 ;0 , 0 , 1 , 0 ]* X_x_kkm1(:, sp);
    end
    
    xHat(:,k) = W_m_0 * X_x_kkm1(:, 1) + W_i * sum(X_x_kkm1(:, 2:end), 2);
    z_kkm1 = W_m_0 * Z_kkm1(:, 1)   + W_i * sum(Z_kkm1(:, 2:end), 2);
    X_x_kkm1 = bsxfun(@minus, X_x_kkm1, xHat(:,k));
    Z_kkm1   = bsxfun(@minus, Z_kkm1, z_kkm1);
    P_kkm1 =   (W_c_0 * X_x_kkm1(:, 1)) * X_x_kkm1(:, 1).'+ W_i * (X_x_kkm1(:, 2:end) * X_x_kkm1(:, 2:end).');
    P_zz =   (W_c_0 * Z_kkm1(:, 1)) * Z_kkm1(:, 1).'+ W_i * (Z_kkm1(:, 2:end) * Z_kkm1(:, 2:end).');
    P_xz =   (W_c_0 * X_x_kkm1(:, 1)) * Z_kkm1(:, 1).' + W_i * (X_x_kkm1(:, 2:end) * Z_kkm1(:, 2:end).');
    K = P_xz / P_zz;
    xHat(:,k) = xHat(:,k) + K * (z_k - z_kkm1);
    P = P_kkm1 - K * P_zz * K.';    
end
end
