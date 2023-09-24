close
clear
clc


[N, Ts, m, M, g, l, P, Q, R, u, x0, xStateInit] = set_parameters;
[w, v] = set_noise(Q, R, N);

[xState, xHat_UKF, xHat_EKF, xHat_PF, t] = EKF_UKF_PF(N, Ts, m, M, g, l, P, Q, R, u, x0, xStateInit, w, v);

for i=1:1:size(xState,1)
    figure(i);
    plot(t, xState(i,:),'m-','Linewidth',2);
    hold on;
    plot(t, xHat_UKF(i,:),'b:','Linewidth',1.7);
    grid on;
    plot(t, xHat_EKF(i,:),'r-','Linewidth',1.5);
    grid on;
    plot(t, xHat_PF(i,:),'g:','Linewidth',1.4);
    grid on;
    xlabel('Time (s)'); 
    ylabel(strcat('State X',string(i)));
    legend('SIGNAL','Estimated UKF','Estimated EKF','Estimated PF');
end
