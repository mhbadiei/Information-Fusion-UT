clear;
close;
clc;

%% retrieving data from Data.xlsx and storing in A matrix.
[data, text] = xlsread('data\Data.xlsx');
A = data;
A_s = A(:,(1:3));
[B, OrigColIdx] = sort(A_s,2,'descend');
[num_iteration, num_sensors] = size(B);

%% Learning OWA operators from observations
w = zeros(num_sensors, 1);
landa_itr = 10;
sigma_landa = zeros(landa_itr,1) ;
d_hat = zeros(num_iteration,landa_itr);
landa = zeros(num_sensors,landa_itr);
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
    for i=1:1:num_sensors
       sigma_landa(j) = sigma_landa(j) + exp(landa(i,j)) ;
    end
    for i=1:1:num_sensors
       w(i) = exp(landa(i,j))/sigma_landa(j); 
    end
    d_hat(:,j) = B*w;
    for i=1:1:num_sensors
       landa(i,j+1) = landa(i,j) - beta*w(i)*dot((B(:,i)-d_hat(:,j)),(d_hat(:,j)-A(:,4))); 
    end
    
    % calculate MSE Error
    for k=1:1:num_iteration
        MSE(j) = MSE(j)+(1/num_iteration)*((A(k,4) - d_hat(k,j))^2);
    end
    MSE_Error = MSE(j);
    
    % calculate RMSE Error
    for k=1:1:num_iteration
        RMSE(j) = RMSE(j)+(1/num_iteration)*((A(k,4) - d_hat(k,j))^2);
    end
    RMSE_Error = sqrt(RMSE(j));
    
    % calculate MAE Error
    for k=1:1:num_iteration
        MAE(j) = MAE(j)+(1/num_iteration)*(abs(A(k,4) - d_hat(k,j)));
    end
    MAE_Error = MAE(j);
    
end
F = d_hat(:,landa_itr)';
%% print w in the terminal
w;

%% print Orness and Dispersion in the terminal
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

colNames = {'Orness' 'Dispersion' 'MSE' 'RMSE'  'MAE' 'w1' 'w2' 'w3'};
Learning_Method_from_Observations_Table = array2table([orness, Dispersion, MSE_Error, RMSE_Error, MAE_Error, w(1), w(2), w(3)],'VariableNames',colNames,'RowNames',{'Learning Method'})

%% plot estimated and read output in the same figure
plot(d_hat(:,landa_itr))
title('Learning')
xlabel('iteration index')
ylabel('Learning OWA')