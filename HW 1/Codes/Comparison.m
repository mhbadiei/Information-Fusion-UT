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
w_Optimistic = [0.6 0.24 0.16];

orness_Optimistic = 0;
for i=1:1:num_sensors
        orness_Optimistic = orness_Optimistic + (1./(num_sensors-1))*((num_sensors-i)*w_Optimistic(i));  
end
orness_Optimistic;

Dispersion_Optimistic = 0;
for i=1:1:num_sensors
        Dispersion_Optimistic = Dispersion_Optimistic - w_Optimistic(i)*log(w_Optimistic(i));  
end
Dispersion_Optimistic;

F_Optimistic = zeros(1,n);
for k=1:1:n
    for i=1:1:num_sensors
        F_Optimistic(k) = F_Optimistic(k) + w_Optimistic(i)*B(k,i);  
    end
end    

%plot(x,F_Pessimistic,'G');
%title('optimistic exponential')
%xlabel('iteration index')
%ylabel('F OWA')

%% Mean-squared Error
MSE_Optimistic = 0;
for j=1:1:num_iteration
    MSE_Optimistic = MSE_Optimistic+(1/num_iteration)*((A(j,4) - F_Optimistic(k))^2);   
end

%% Root-mean-square Error
RMSE_Optimistic = 0;
for j=1:1:num_iteration
       RMSE_Optimistic = RMSE_Optimistic +(1/num_iteration)*((A(j,4) - F_Optimistic(k))^2);  
end
RMSE_Optimistic = sqrt(RMSE_Optimistic);

%% Mean absolute Error
MAE_Optimistic = 0;
for j=1:1:num_iteration
       MAE_Optimistic = MAE_Optimistic+(1/num_iteration)*(abs(A(j,4) - F_Optimistic(k)));  
end

%colNames = {'Orness' 'Dispersion' 'MSE' 'RMSE'  'MAE' 'w1' 'w2' 'w3'};
%Optimistic_Exponential_Table = array2table([orness_Optimistic, Dispersion_Optimistic, MSE_Optimistic, RMSE_Optimistic, MAE_Optimistic, w_Optimistic(1), w_Optimistic(2), w_Optimistic(3)],'VariableNames',colNames,'RowNames',{'Optimistic Method'})

w_Pessimistic = [0.5929 0.1771 0.23];

orness_Pessimistic = 0;
for i=1:1:num_sensors
        orness_Pessimistic = orness_Pessimistic + (1./(num_sensors-1))*((num_sensors-i)*w_Pessimistic(i));  
end
orness_Pessimistic;

Dispersion_Pessimistic = 0;
for i=1:1:num_sensors
        Dispersion_Pessimistic = Dispersion_Pessimistic - w_Pessimistic(i)*log(w_Pessimistic(i));  
end
Dispersion_Pessimistic;

F_Pessimistic = zeros(1,n);
for k=1:1:n
    for i=1:1:num_sensors
        F_Pessimistic(k) = F_Pessimistic(k) + w_Pessimistic(i)*B(k,i);  
    end
end    

%plot(x,F_Pessimistic,'R');
%title('pessimistic exponential')
%xlabel('iteration index')
%ylabel('F OWA')

%% Mean-squared Error
MSE_Pessimistic = 0;
for j=1:1:num_iteration
    MSE_Pessimistic = MSE_Pessimistic+(1/num_iteration)*((A(j,4) - F_Pessimistic(k))^2);   
end

%% Root-mean-square Error
RMSE_Pessimistic = 0;
for j=1:1:num_iteration
       RMSE_Pessimistic = RMSE_Pessimistic +(1/num_iteration)*((A(j,4) - F_Pessimistic(k))^2);  
end
RMSE_Pessimistic = sqrt(RMSE_Pessimistic);

%% Mean absolute Error
MAE_Pessimistic = 0;
for j=1:1:num_iteration
       MAE_Pessimistic = MAE_Pessimistic+(1/num_iteration)*(abs(A(j,4) - F_Pessimistic(k)));  
end

%colNames = {'Orness' 'Dispersion' 'MSE' 'RMSE'  'MAE' 'w1' 'w2' 'w3'};
%Pessimistic_Exponential_Table = array2table([orness_Pessimistic, Dispersion_Pessimistic, MSE_Pessimistic, RMSE_Pessimistic, MAE_Pessimistic, w_Pessimistic(1), w_Pessimistic(2), w_Pessimistic(3)],'VariableNames',colNames,'RowNames',{'Pessimistic Method'})

p = [0.2 0.1 0.7];
init_w_WOWA = [0.66 0.24 0.1];
input_x = [1./3 2./3 3./3 0];
input_y = [init_w_WOWA,0];
%cftool(input_x,input_y);

s1 =6.12;s2 =-10.98;s3 =4.96;s4 =0;
w_star(z) = s1*z^3 + s2*z^2 + s3*z + s4;

w_WOWA = zeros(1,num_sensors);
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
    w_WOWA(1,i) = w_star(sum1) - w_star(sum2);
end
w_WOWA;

orness_WOWA = 0;
for i=1:1:num_sensors
        orness_WOWA = orness_WOWA + (1./(num_sensors-1))*((num_sensors-i)*w_WOWA(i));  
end
orness_WOWA;

Dispersion_WOWA = 0;
for i=1:1:num_sensors
        Dispersion_WOWA = Dispersion_WOWA - w_WOWA(i)*log(w_WOWA(i));  
end
Dispersion_WOWA;

F_WOWA = zeros(1,n);
for k=1:1:n
    for i=1:1:num_sensors
        F_WOWA(k) = F_WOWA(k) + w_WOWA(i)*B(k,i);  
    end
end    

%plot(x,F_WOWA);
%title('WOWA')
%xlabel('iteration index')
%ylabel('F OWA')

%% Mean-squared Error
MSE_WOWA = 0;
for j=1:1:num_iteration
    MSE_WOWA = MSE_WOWA+(1/num_iteration)*((A(j,4) - F_WOWA(k))^2);   
end

%% Root-mean-square Error
RMSE_WOWA = 0;
for j=1:1:num_iteration
       RMSE_WOWA = RMSE_WOWA +(1/num_iteration)*((A(j,4) - F_WOWA(k))^2);  
end
RMSE_WOWA = sqrt(RMSE_WOWA);

%% Mean absolute Error
MAE_WOWA = 0;
for j=1:1:num_iteration
       MAE_WOWA = MAE_WOWA+(1/num_iteration)*(abs(A(j,4) - F_WOWA(k)));  
end

%colNames = {'Orness' 'Dispersion' 'MSE' 'RMSE'  'MAE' 'w1' 'w2' 'w3'};
%WOWA_Table = array2table([orness_WOWA, Dispersion_WOWA, MSE_WOWA, RMSE_WOWA, MAE_WOWA, w_WOWA(1), w_WOWA(2), w_WOWA(3)],'VariableNames',colNames,'RowNames',{'WOWA Method'})

mu_dependent = zeros(1,n);
sigma_dependent = zeros(1,n);

for j=1:1:n
    sum_dependent = 0;
    for i= 1:1:num_sensors
        sum_dependent = sum_dependent + B(j,i);
    end
    
    mu_dependent(j) = (1/num_sensors).*sum_dependent;
    
    for i= 1:1:num_sensors
        sigma_dependent(j) = sigma_dependent(j) + abs(B(j,i) - mu_dependent(j));
    end
end

s_dependent = zeros(n,num_sensors);
for j=1:1:n
    for i=1:1:num_sensors
        s_dependent(j,i) = 1 - (abs(B(j,i)-mu_dependent(1,j))/sigma_dependent(1,j));
    end
    %j
    %s(j,:)
end

s_dependent_sum = zeros(n,1);
for j=1:1:n
    for i=1:1:num_sensors
        s_dependent_sum(j,1) = s_dependent_sum(j,1) + s_dependent(j,i);
    end
    %j
    %s_sum(j)
end

w_dependent_1 = zeros(n,num_sensors);
for j=1:1:n
   for i=1:1:num_sensors
      w_dependent_1(j,i)= s_dependent(j,i)/s_dependent_sum(j);
   end
end
w_dependent_1;
%size(w)

orness_dependent_1 = zeros(n,1);
for j=1:1:n
    for i=1:1:num_sensors
        orness_dependent_1(j,1) = orness_dependent_1(j,1) + (1./(num_sensors-1))*((num_sensors-i)*w_dependent_1(j,i));  
    end
    
end
orness_dependent_1;

Dispersion_dependent_1 = zeros(n,1);
for j=1:1:n
    for i=1:1:num_sensors
        Dispersion_dependent_1(j,1) = Dispersion_dependent_1(j,1) - w_dependent_1(j,i)*log(w_dependent_1(j,i));  
    end
end
Dispersion_dependent_1;

F_dependent = zeros(1,n);
for k=1:1:n
    for i=1:1:num_sensors
        F_dependent(k) = F_dependent(k) + w_dependent_1(k,i)*B(k,i);  
    end
end    
%F_dependent
%plot(x,F_dependent,'c');
%title('dependent')
%xlabel('iteration index')
%ylabel('F OWA')

%% Mean-squared Error
MSE_dependent = 0;
for j=1:1:num_iteration
    MSE_dependent = MSE_dependent+(1/num_iteration)*((A(j,4) - F_dependent(k))^2);   
end

%% Root-mean-square Error
RMSE_dependent = 0;
for j=1:1:num_iteration
       RMSE_dependent = RMSE_dependent +(1/num_iteration)*((A(j,4) - F_dependent(k))^2);  
end
RMSE_dependent = sqrt(RMSE_dependent);

%% Mean absolute Error
MAE_dependent = 0;
for j=1:1:num_iteration
       MAE_dependent = MAE_dependent+(1/num_iteration)*(abs(A(j,4) - F_dependent(k)));  
end
orness_dependent = orness_dependent_1(n);
Dispersion_dependent = Dispersion_dependent_1(n);
w_dependent = [w_dependent_1(n,1), w_dependent_1(n,2), w_dependent_1(n,3)];

%colNames = {'Orness' 'Dispersion' 'MSE' 'RMSE'  'MAE' 'w1' 'w2' 'w3'};
%Dependent_Table = array2table([orness_dependent, Dispersion_dependent, MSE_dependent, RMSE_dependent, MAE_dependent, w_dependent(1), w_dependent(2), w_dependent(3)],'VariableNames',colNames,'RowNames',{'Dependent Method'})

w_OHagan = [0.5540 0.2921 0.1540];

orness_OHagan = 0;
for i=1:1:num_sensors
        orness_OHagan = orness_OHagan + (1./(num_sensors-1))*((num_sensors-i)*w_OHagan(i));  
end
orness_OHagan;

Dispersion_OHagan = 0;
for i=1:1:num_sensors
        Dispersion_OHagan = Dispersion_OHagan - w_OHagan(i)*log(w_OHagan(i));  
end
Dispersion_OHagan;

F_OHagan = zeros(1,n);
for k=1:1:n
    for i=1:1:num_sensors
        F_OHagan(k) = F_OHagan(k) + w_OHagan(i)*B(k,i);  
    end
end    


%plot(x,F_OHagan,'m');
%title('OHagan')
%xlabel('iteration index')
%ylabel('F OWA')

%% Mean-squared Error
MSE_OHagan = 0;
for j=1:1:num_iteration
    MSE_OHagan = MSE_OHagan+(1/num_iteration)*((A(j,4) - F_OHagan(k))^2);   
end

%% Root-mean-square Error
RMSE_OHagan = 0;
for j=1:1:num_iteration
       RMSE_OHagan = RMSE_OHagan +(1/num_iteration)*((A(j,4) - F_OHagan(k))^2);  
end
RMSE_OHagan = sqrt(RMSE_OHagan);

%% Mean absolute Error
MAE_OHagan = 0;
for j=1:1:num_iteration
       MAE_OHagan = MAE_OHagan+(1/num_iteration)*(abs(A(j,4) - F_OHagan(k)));  
end

%colNames = {'Orness' 'Dispersion' 'MSE' 'RMSE'  'MAE' 'w1' 'w2' 'w3'};
%OHagan_Table = array2table([orness_OHagan, Dispersion_OHagan, MSE_OHagan, RMSE_OHagan, MAE_OHagan, w_OHagan(1), w_OHagan(2), w_OHagan(3)],'VariableNames',colNames,'RowNames',{'OHagan Method'})

%% Learning OWA operators from observations
w_Learning = zeros(num_sensors, 1);
landa_itr_Learning = 10;
sigma_landa_Learning = zeros(landa_itr_Learning,1) ;
d_hat_Learning = zeros(num_iteration,landa_itr_Learning);
landa_Learning = zeros(num_sensors,landa_itr_Learning);
beta_Learning = 0.35;
landa_Learning(:,1)=[0.3;0.4;0.2];

MSE = zeros(landa_itr_Learning,1);
MSE_Learning = 0;
RMSE = zeros(landa_itr_Learning,1);
RMSE_Learning = 0;
MAE = zeros(landa_itr_Learning,1);
MAE_Learning = 0;
for j=1:1:landa_itr_Learning
    sigma_landa_Learning(j) = 0;
    for i=1:1:num_sensors
       sigma_landa_Learning(j) = sigma_landa_Learning(j) + exp(landa_Learning(i,j)) ;
    end
    for i=1:1:num_sensors
       w_Learning(i) = exp(landa_Learning(i,j))/sigma_landa_Learning(j); 
    end
    d_hat_Learning(:,j) = B*w_Learning;
    for i=1:1:num_sensors
       landa_Learning(i,j+1) = landa_Learning(i,j) - beta_Learning*w_Learning(i)*dot((B(:,i)-d_hat_Learning(:,j)),(d_hat_Learning(:,j)-A(:,4))); 
    end
    
    % calculate MSE Error
    for k=1:1:num_iteration
        MSE(j) = MSE(j)+(1/num_iteration)*((A(k,4) - d_hat_Learning(k,j))^2);
    end
    MSE_Learning = MSE(j);
    
    % calculate RMSE Error
    for k=1:1:num_iteration
        RMSE(j) = RMSE(j)+(1/num_iteration)*((A(k,4) - d_hat_Learning(k,j))^2);
    end
    RMSE_Learning = sqrt(RMSE(j));
    
    % calculate MAE Error
    for k=1:1:num_iteration
        MAE(j) = MAE(j)+(1/num_iteration)*(abs(A(k,4) - d_hat_Learning(k,j)));
    end
    MAE_Learning = MAE(j);
    
end
F_Learning = d_hat_Learning(:,landa_itr_Learning)';
%% print w in the terminal
w_Learning;

%% print Orness and Dispersion in the terminal
orness_Learning = 0;
for i=1:1:num_sensors
        orness_Learning = orness_Learning + (1./(num_sensors-1))*((num_sensors-i)*w_Learning(i));  
end
orness_Learning;

Dispersion_Learning = 0;
for i=1:1:num_sensors
        Dispersion_Learning = Dispersion_Learning - w_Learning(i)*log(w_Learning(i));  
end
Dispersion_Learning;

%colNames = {'Orness' 'Dispersion' 'MSE' 'RMSE'  'MAE' 'w1' 'w2' 'w3'};
%Learning_Method_from_Observations_Table = array2table([orness_Learning, Dispersion_Learning, MSE_Learning, RMSE_Learning, MAE_Learning, w_Learning(1), w_Learning(2), w_Learning(3)],'VariableNames',colNames,'RowNames',{'Learning Method'})

%plot(d_hat_Learning(:,landa_itr_Learning))
%title('Learning')
%xlabel('iteration index')
%ylabel('Learning OWA')

colNames = {'Orness' 'Dispersion' 'MSE' 'RMSE'  'MAE' 'w1' 'w2' 'w3'};
rowNames = {'Optimistic', 'Pessimistic', 'WOWA', 'dependent', 'OHagan', 'Learning'};
orness = [orness_Optimistic;orness_Pessimistic;orness_WOWA;orness_dependent;orness_OHagan;orness_Learning];
Dispersion = [Dispersion_Optimistic;Dispersion_Pessimistic;Dispersion_WOWA;Dispersion_dependent;Dispersion_OHagan;Dispersion_Learning];
MSE_Error = [MSE_Optimistic;MSE_Pessimistic;MSE_WOWA;MSE_dependent;MSE_OHagan;MSE_Learning];
RMSE_Error = [RMSE_Optimistic;RMSE_Pessimistic;RMSE_WOWA;RMSE_dependent;RMSE_OHagan;RMSE_Learning];
MAE_Error = [MAE_Optimistic;MAE_Pessimistic;MAE_WOWA;MAE_dependent;MAE_OHagan;MAE_Learning];
w = zeros(6,3);
w(:,1) = [w_Optimistic(1);w_Pessimistic(1);w_WOWA(1);w_dependent(1);w_OHagan(1);w_Learning(1)];
w(:,2) = [w_Optimistic(2);w_Pessimistic(2);w_WOWA(2);w_dependent(2);w_OHagan(2);w_Learning(2)];
w(:,3) = [w_Optimistic(3);w_Pessimistic(3);w_WOWA(3);w_dependent(3);w_OHagan(3);w_Learning(3)];
Methods_Table = array2table([orness, Dispersion, MSE_Error, RMSE_Error, MAE_Error, w(:,1), w(:,2), w(:,3)],'VariableNames',colNames,'RowNames',rowNames)

subplot(3,2,1);
plot(x,F_Optimistic);
hold on
plot(A(:,4),'R')
title('optimistic exponential')
xlabel('iteration index')
ylabel('F OWA')

subplot(3,2,2);
plot(x,F_Pessimistic);
hold on
plot(A(:,4),'R')
title('Pessimistic exponential')
xlabel('iteration index')
ylabel('F OWA')

subplot(3,2,3);
plot(x,F_WOWA);
hold on
plot(A(:,4),'R')
title('WOWA')
xlabel('iteration index')
ylabel('F OWA')

subplot(3,2,4);
plot(x,F_dependent);
hold on
plot(A(:,4),'R')
title('dependent')
xlabel('iteration index')
ylabel('F OWA')

subplot(3,2,5);
plot(x,F_OHagan);
hold on
plot(A(:,4),'R')
title('OHagan')
xlabel('iteration index')
ylabel('F OWA')

subplot(3,2,6);
plot(x,F_Learning);
hold on
plot(A(:,4),'R')
title('Learning')
xlabel('iteration index')
ylabel('F OWA')
