clear;
close;
clc;

%% retrieving data from Data.xlsx and storing in A matrix.
[data, text] = xlsread('data\Data.xlsx');
A = data;
A_s = A(:,(1:3));
[B, OrigColIdx] = sort(A_s,2,'descend');
[n_itr, m_sensor] = size(A);

%% Learning OWA operators from observations
w = zeros(m_sensor-1, 1);
landa_itr = 10;
sigma_landa = zeros(landa_itr,1) ;
d_hat = zeros(n_itr,landa_itr);
landa = zeros(m_sensor-1,landa_itr);
beta = 0.35;
landa(:,1)=[0.3;0.4;0.2];

MSE = zeros(landa_itr,1);
MSE_Error = 0;
RMSE = zeros(landa_itr,1);
RMSE_Error = 0;
MAE = zeros(landa_itr,1);
MAE_Error = 0;
for j=1:1:landa_itr
    
    sigma_landa(j) = 0;
    for i=1:1:m_sensor-1
       sigma_landa(j) = sigma_landa(j) + exp(landa(i,j)) ;
    end
    for i=1:1:m_sensor-1
       w(i) = exp(landa(i,j))/sigma_landa(j); 
    end
    d_hat(:,j) = B*w;
    for i=1:1:m_sensor-1
       landa(i,j+1) = landa(i,j) - beta*w(i)*dot((B(:,i)-d_hat(:,j)),(d_hat(:,j)-A(:,4))); 
    end
    
    % calculate MSE Error
    for k=1:1:n_itr
        MSE(j) = MSE(j)+(1/n_itr)*((A(k,4) - d_hat(k,j))^2);
    end
    MSE_Error = MSE(j);
    
    % calculate RMSE Error
    for k=1:1:n_itr
        RMSE(j) = RMSE(j)+(1/n_itr)*((A(k,4) - d_hat(k,j))^2);
    end
    RMSE_Error = sqrt(RMSE(j));
    
    % calculate MAE Error
    for k=1:1:n_itr
        MAE(j) = MAE(j)+(1/n_itr)*(abs(A(k,4) - d_hat(k,j)));
    end
    MAE_Error = MAE(j);
    
end

%% print w in the terminal
w;

%% calculate e = y - y_hat
e = A(:,4) - d_hat(:,landa_itr); 

%% calculate Mean and Variance
sum=0;
for i=1:length(e)
  sum = sum + e(i);
end
Mean = sum/length(e); %the mean
sum_mean_diff=0;
for i=1:length(e)
    sum_mean_diff=sum_mean_diff+ (e(i)-Mean)^2;
end
Variance=sum_mean_diff/length(e); %Variance

colNames = {'Mean' 'Variance'};
MEAN_VARIANCE_Table = array2table([Mean, Variance],'VariableNames',colNames)

x = -0.8:0.00001:0.8;
G = gaussmf(x,[Variance Mean]);
figure(1)
plot(x,G,'LineWidth',2)
ylim([0 1.5])
xlim([-0.4 0.4])
title('plot a gaussian function with mean and variance of error')
xlabel('x')
ylabel('Y')
legend('gaussian function')
figure(2)
plot(x,G,'LineWidth',2.5)
ylim([0 1.5])
xlim([-0.4 0.4])
hold on

gaus = @(x,mu,sig)exp(-(((x-mu).^2)/(2*sig.^2)));
y = gaus(e,Mean,Variance);
% Plot gaussian
plot(e, y, 'ro','markersize', 1)
title('compare gaussian function to error gaussian function')
xlabel('x')
ylabel('Y')
legend('gaussian function', 'err-gaussian function')

