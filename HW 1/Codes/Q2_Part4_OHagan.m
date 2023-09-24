clear;
close;
clc;

%% retrieving data from Data.xlsx and storing in A matrix.
[data, text] = xlsread('data\Data.xlsx');
A = data;
A_s = A(:,(1:3));
[B, OrigColIdx] = sort(A_s,2,'descend');
%B = transpose(sort(transpose(A),'descend'))

[num_iteration,num_sensors] = size(B);
n = num_iteration; 
x = 1:1:n;
w = [0.5540 0.2921 0.1540];

orness = 0;
for i=1:1:num_sensors
        orness = orness + (1./(num_sensors-1))*((num_sensors-i)*w(i));  
end
orness;

Dispersion = 0;
for i=1:1:num_sensors
        Dispersion = Dispersion - w(i)*log(w(i));  
end
Dispersion;

F = zeros(1,n);
for k=1:1:n
    for i=1:1:num_sensors
        F(k) = F(k) + w(i)*B(k,i);  
    end
end    

plot(x,F,'m');
title('OHagan')
xlabel('iteration index')
ylabel('F OWA')

%% Mean-squared Error
MSE = 0;
for j=1:1:num_iteration
    MSE = MSE+(1/num_iteration)*((A(j,4) - F(k))^2);   
end

%% Root-mean-square Error
RMSE = 0;
for j=1:1:num_iteration
       RMSE = RMSE +(1/num_iteration)*((A(j,4) - F(k))^2);  
end
RMSE = sqrt(RMSE);

%% Mean absolute Error
MAE = 0;
for j=1:1:num_iteration
       MAE = MAE+(1/num_iteration)*(abs(A(j,4) - F(k)));  
end

colNames = {'Orness' 'Dispersion' 'MSE' 'RMSE'  'MAE' 'w1' 'w2' 'w3'};
OHagan_Table = array2table([orness, Dispersion, MSE, RMSE, MAE, w(1), w(2), w(3)],'VariableNames',colNames,'RowNames',{'OHagan Method'})

