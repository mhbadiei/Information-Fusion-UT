S([0.3,0.6,0.7,0.3],[1.0,0.8,0.1,0.8])

function res = S(mu,f)
[n,m]= size(f);

Gs = zeros(1,n);


[sorted, index] = sort(f, 'descend')

for i=1:1:m
   Gs(1,i) = mu(index(i)); 
end
Gs
end