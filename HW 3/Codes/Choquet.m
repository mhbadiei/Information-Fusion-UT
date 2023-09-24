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