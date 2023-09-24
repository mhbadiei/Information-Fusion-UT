function [xState, xHat_UKF, xHat_EKF, xHat_PF, t] = EKF_UKF_PF(N, Ts, m, M, g, l, P, Q, R, u, x0, xStateInit, w, v)

t=0:Ts:Ts*(N-1);

xState(:, 1) = xStateInit; 
for k = 2:N
    xState(:,k) = xState(:,k-1)+Ts*[xState(2,k-1);(u*cos(xState(1,k-1))-(M+m)*g*sin(xState(1,k-1))+m*l*(cos(xState(1,k-1)))*(sin(xState(1,k-1)))*xState(2,k-1)*xState(2,k-1))/(m*l*(cos(xState(1,k-1)))*cos(xState(1,k-1))-(M+m)*l) ;xState(4,k-1);(u+m*l*(sin(xState(1,k-1)))*(xState(2,k-1)*xState(2,k-1))-m*g*sin(xState(1,k-1))*cos(xState(1,k-1)))/(M+m-m*cos(xState(1,k-1))*cos(xState(1,k-1)))] + w(:,k-1);
end

xHat_UKF = UKF(N, Ts, m, M, g, l, P, Q, R, u, x0, xStateInit, w, v);

xHat_EKF = EKF(N, Ts, m, M, g, l, P, Q, R, u, x0, xStateInit, w, v);

xHat_PF = PF(N, Ts, m, M, g, l, P, Q, R, u, x0, xStateInit, w, v);
end