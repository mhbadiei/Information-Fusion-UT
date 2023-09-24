function xHat=EKF(N, Ts, m, M, g, l, P, Q, R, u, x0, xStateInit, w, v)

xState(:, 1) = xStateInit; 
xHat = zeros(4, N);
xHat(:, 1) = x0;

%[f, h]=set_functions;

x = sym('x',[1 4]);
syms(x)
f_func(x) =[x(2)*Ts+x(1);...
                 ((u*cos(x(1))-(M+m)*g*sin(x(1))+m*l*(cos(x(1)))*(sin(x(1)))*x(2)*x(2))/(m*l*(cos(x(1)))*cos(x(1))-(M+m)*l))*Ts+x(2) ;...
                 x(4)*Ts+x(3);...
                 ((u+m*l*(sin(x(1)))*(x(2)*x(2))-m*g*sin(x(1))*cos(x(1)))/(M+m-m*cos(x(1))*cos(x(1))))*Ts+x(4)];
h_func(x) =[x(1); x(3)];

SymbolicSystem = sym(f_func);
SymbolicJacobian = jacobian(SymbolicSystem',x);
F_fcn = matlabFunction(SymbolicJacobian,'var',x);

SymbolicSystem = sym(h_func);
SymbolicJacobian = jacobian(SymbolicSystem',x);
H_fcn = matlabFunction(SymbolicJacobian,'var',x);

for k = 2:N
    xState(:,k) = xState(:,k-1)+Ts*[xState(2,k-1) ;(u*cos(xState(1,k-1))-(M+m)*g*sin(xState(1,k-1))+m*l*(cos(xState(1,k-1)))*(sin(xState(1,k-1)))*xState(2,k-1)*xState(2,k-1))/(m*l*(cos(xState(1,k-1)))*cos(xState(1,k-1))-(M+m)*l) ;xState(4,k-1) ;(u+m*l*(sin(xState(1,k-1)))*(xState(2,k-1)*xState(2,k-1))-m*g*sin(xState(1,k-1))*cos(xState(1,k-1)))/(M+m-m*cos(xState(1,k-1))*cos(xState(1,k-1)))] + w(:,k-1);
end

for k = 2:N
    
    f = xHat(:,k-1)+Ts*[xHat(2,k-1);(u*cos(xHat(1,k-1))-(M+m)*g*sin(xHat(1,k-1))+m*l*(cos(xHat(1,k-1)))*(sin(xHat(1,k-1)))*xHat(2,k-1)*xHat(2,k-1))/(m*l*(cos(xHat(1,k-1)))*cos(xHat(1,k-1))-(M+m)*l) ;xHat(4,k-1) ;(u+m*l*(sin(xHat(1,k-1)))*(xHat(2,k-1)*xHat(2,k-1))-m*g*sin(xHat(1,k-1))*cos(xHat(1,k-1)))/(M+m-m*cos(xHat(1,k-1))*cos(xHat(1,k-1)))]+w(:,k-1);
    h = [1 , 0 , 0 , 0 ;0 , 0 , 1 , 0 ]*xHat(:,k)+v(:,k-1);
    S_K_1 = num2cell(xHat(:,k-1));
    S_K = num2cell(xHat(:,k));
    z = [1 , 0 , 0 , 0 ; 0 , 0 , 1 , 0 ]*xHat(:,k);
    F = F_fcn(S_K_1{:});
    xHat(:,k) = f;    
    P = F * P * F' + Q;
    z_hat = h;
    y = z - z_hat;
    H = H_fcn(S_K{:});
    P_xy = P * H';
    P_yy = H * P * H' + R;
    K = P_xy / P_yy;
    xHat(:,k) = xHat(:,k) + K * y;
    A = eye(length(xHat(:,k))) - K * H;
    P = A * P * A' + K * R * K';
end
end
