clear;
close;
clc;
syms z

%% retrieving data from Data.xlsx and storing in A matrix.
[data, text] = xlsread('data\Data.xlsx');
A = data;
A_s = A(:,(1:3));
[B, OrigColIdx] = sort(A_s,2,'descend');
%B = transpose(sort(transpose(A),'descend'))

[num_iteration,num_sensors] = size(B);
n = num_iteration; 
x = 1:1:n;

p = [0.2 0.1 0.7];
init_w = [0.66 0.24 0.1];
input_x = [1./3 2./3 3./3 0];
input_y = [init_w,0];
%cftool(input_x,input_y);

s1 =6.12;s2 =-10.98;s3 =4.96;s4 =0;
w_star(z) = s1*z^3 + s2*z^2 + s3*z + s4;

w = zeros(1,num_sensors);
for i=1:1:num_sensors
    sum1 = 0;
    sum2 = 0;
    for j=1:1:num_sensors
        if j<= i
            sum1 = sum1 + p(j);
        else
            sum2 = sum2 + p(j);
        end
    end
    w(1,i) = w_star(sum1) - w_star(sum2);
end
w;

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

plot(x,F);
title('WOWA')
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
WOWA_Table = array2table([orness, Dispersion, MSE, RMSE, MAE, w(1), w(2), w(3)],'VariableNames',colNames,'RowNames',{'WOWA Method'})
