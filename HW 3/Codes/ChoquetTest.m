clear;close;clc;

colNames = {'Movie_A' 'Movie_B' 'Movie_C' 'Movie_D'};
rowNames = {'1st_section', '2nd_section', '3rd_section3', '4th_section4'};
Table = array2table([Choquet([0.3,0.6,0.7,0.3],[1.0,0.8,0.1,0.8]),...
    Choquet([0.3,0.6,0.7,0.3],[0.5,0.5,0.3,0.7]),...
    Choquet([0.3,0.6,0.7,0.3],[0.3,0.3,0.2,0.4]),...
    Choquet([0.3,0.6,0.7,0.3],[0.3,0.3,0.8,0.8]);...
    Choquet([0.3,0.6],[1.0,0.8]),...
    Choquet([0.3,0.6],[0.5,0.5]),...
    Choquet([0.3,0.6],[0.3,0.3]),...
    Choquet([0.3,0.6],[0.3,0.3]);...
    Choquet([0.7,0.3],[0.1,0.8]),...
    Choquet([0.7,0.3],[0.3,0.7]),...
    Choquet([0.7,0.3],[0.2,0.4]),...
    Choquet([0.7,0.3],[0.8,0.8]);...
    Choquet([0.6,0.7],[0.8,0.1]),...
    Choquet([0.6,0.7],[0.5,0.3]),...
    Choquet([0.6,0.7],[0.3,0.2]),...
    Choquet([0.6,0.7],[0.3,0.8]),...
    ],'VariableNames',colNames,'RowNames',rowNames)


function res = Choquet(mu, f)
syms x

n = size(mu,2);

lambdaCalFunc = 1;
for i=1:1:n
     lambdaCalFunc = lambdaCalFunc*(1+ x*mu(1,i));
end
C = coeffs(expand(lambdaCalFunc - x - 1),'All');
digits(6)
r = vpa(roots(C));
mr = size(r,1);

lambda = 0;
if sum(mu) == 1
    lambda = 0;
elseif sum(mu) > 1
   for i=1:1:mr 
        if isreal(r(i,1)) && r(i,1)>-1 && r(i,1)<0
             lambda = r(i,1);
        end
   end
else
   for i=1:1:mr 
        if isreal(r(i,1)) && r(i,1)>0
             lambda = r(i,1);
        end
   end
end

F = [mu' f'];
A = zeros(n,2);
for i=1:1:n
    [a, index]=max(F(:,2));
    A(i,:) = [F(index,1) a];
    F(index,:)=[];
end

GAi = zeros(n,2);
Gi = 0;
for i=1:1:n
    
    Gi = Gi + A(i,1) + lambda*Gi*A(i,1);    
    
    GAi(i,:) = [Gi, A(i,2)];
end

result = 0;
previousVal = 0;
for i=1:1:n
   result = result+(GAi(n-i+1,2) - previousVal)*GAi(n-i+1,1);
   previousVal = GAi(n-i+1,2);
end
res = result;

end