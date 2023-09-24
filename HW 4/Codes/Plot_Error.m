close
clear
clc

sim_number = 100;
EKF_ERROR = zeros(4,sim_number);
UKF_ERROR = zeros(4,sim_number);
PF_ERROR = zeros(4,sim_number);

for i=1:1:sim_number
    i
    [N, Ts, m, M, g, l, P, Q, R, u, x0, xStateInit] = set_parameters;
    [w, v] = set_noise(Q, R, N);

    [xState, xHat_UKF, xHat_EKF, xHat_PF, t] = EKF_UKF_PF(N, Ts, m, M, g, l, P, Q, R, u, x0, xStateInit, w, v);

    EKF_ERROR(:,i) = sqrt((1/N).*sum((xState-xHat_EKF)'.^2))';
    UKF_ERROR(:,i) = sqrt((1/N).*sum((xState-xHat_UKF)'.^2))';
    PF_ERROR(:,i)  = sqrt((1/N).*sum((xState-xHat_PF)'.^2))';
end

for i=1:1:4
    figure(i);
    plot(1:1:sim_number,UKF_ERROR(i,:) ,'b-','Linewidth',2);
    hold on;
    plot(1:1:sim_number,EKF_ERROR(i,:) ,'r-','Linewidth',2);
    grid on;
    plot(1:1:sim_number,PF_ERROR(i,:) ,'m-','Linewidth',2);
    grid on;
    xlabel('iteration'); 
    ylabel(strcat('RMSE criteria of estimation in State X',string(i)));
    legend('UKF ERROR','EKF ERROR','PF ERROR');
end