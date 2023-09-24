clear;
close;
clc;

%% datas related to the question
[data, text] = xlsread('data\Data.xlsx');
A = data;
A_s = A(:,(1:3));
[B, OrigColIdx] = sort(A_s,2,'descend');
%B = transpose(sort(transpose(A),'descend'))

[num_iteration,num_sensors] = size(B);
n = num_iteration; 
x = 1:1:n;

mu = zeros(1,n);
sigma = zeros(1,n);

for j=1:1:n
    sum = 0;
    for i= 1:1:num_sensors
        sum = sum + B(j,i);
    end
    
    mu(j) = (1/num_sensors).*sum;
    
    for i= 1:1:num_sensors
        sigma(j) = sigma(j) + abs(B(j,i) - mu(j));
    end
end

s = zeros(n,num_sensors);
for j=1:1:n
    for i=1:1:num_sensors
        s(j,i) = 1 - (abs(B(j,i)-mu(1,j))/sigma(1,j));
    end
    %j
    %s(j,:)
end

s_sum = zeros(n,1);
for j=1:1:n
    for i=1:1:num_sensors
        s_sum(j,1) = s_sum(j,1) + s(j,i);
    end
    %j
    %s_sum(j)
end

w = zeros(n,num_sensors);
for j=1:1:n
   for i=1:1:num_sensors
      w(j,i)= s(j,i)/s_sum(j);
   end
end
w;
%size(w)

orness = zeros(n,1);
for j=1:1:n
    for i=1:1:num_sensors
        orness(j,1) = orness(j,1) + (1./(num_sensors-1))*((num_sensors-i)*w(j,i));  
    end
    
end
orness;

Dispersion = zeros(n,1);
for j=1:1:n
    for i=1:1:num_sensors
        Dispersion(j,1) = Dispersion(j,1) - w(j,i)*log(w(j,i));  
    end
end
Dispersion;

F = zeros(1,n);
for k=1:1:n
    for i=1:1:num_sensors
        F(k) = F(k) + w(k,i)*B(k,i);  
    end
end    
%F
plot(x,F,'c');
title('dependent')
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
Dependent_Table = array2table([orness(n), Dispersion(n), MSE, RMSE, MAE, w(n,1), w(n,2), w(n,3)],'VariableNames',colNames,'RowNames',{'Dependent Method'})
