clear;
close;
clc;

%% retrieving data from Data.xlsx and storing in A matrix.
[data, text] = xlsread('data\Data.xlsx');
A = data;
[n_itr, m_sensor] = size(A);

%% Mean-squared Error
MSE = zeros(1,m_sensor-1);
for i=1:1:m_sensor-1
    for j=1:1:n_itr
       MSE(i) = MSE(i)+(1/n_itr)*((A(j,4) - A(j,i))^2);  
    end 
end
colNames = {'sensor_1' 'sensor_2'  'sensor_3'};
MSE_Table = array2table(MSE,'VariableNames',colNames)

%% Root-mean-square Error
RMSE = zeros(1,m_sensor-1);
for i=1:1:m_sensor-1
    for j=1:1:n_itr
       RMSE(i) = RMSE(i)+(1/n_itr)*((A(j,4) - A(j,i))^2);  
    end
    RMSE(i) = sqrt(RMSE(i));
end
colNames = {'sensor_1' 'sensor_2'  'sensor_3'};
RMSE_Table = array2table(RMSE,'VariableNames',colNames)

%% Mean absolute Error
MAE = zeros(1,m_sensor-1);
for i=1:1:m_sensor-1
    for j=1:1:n_itr
       MAE(i) = MAE(i)+(1/n_itr)*(abs(A(j,4) - A(j,i)));  
    end
end
colNames = {'sensor_1' 'sensor_2'  'sensor_3'};
MAE_Table = array2table(MAE,'VariableNames',colNames)