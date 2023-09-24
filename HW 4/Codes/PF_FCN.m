function [xhat] = PF_FCN(f,h,pe,Q,x0,P0,N,y,u,m,M,g,l,Ts,w1,v)
nx=size(P0,2);
x = repmat(x0,1,N)+sqrtm(P0)*randn(nx,N); % 1.
xhat = zeros(nx,size(y,2));
for t=1:size(y,2)
    for i=1:1:size(x,2)
        x(:,i) = x(:,i)+Ts*[x(2,i) ;(u*cos(x(1,i))-(M+m)*g*sin(x(1,i))+m*l*(cos(x(1,i)))*(sin(x(1,i)))*x(2,i)*x(2,i))/(m*l*(cos(x(1,i)))*cos(x(1,i))-(M+m)*l) ;x(4,i) ;(u+m*l*(sin(x(1,i)))*(x(2,i)*x(2,i))-m*g*sin(x(1,i))*cos(x(1,i)))/(M+m-m*cos(x(1,i))*cos(x(1,i)))] + w1(:,i);
    end
e = repmat(y(:,t),1,N) - feval(h,x);
w = feval(pe,e); % 3.
w = w/sum(w);
xhat(:,t) = sum(repmat(w,nx,1).*x,2);
index = sysresample(w); % 4.
x = x(:,index);
end
end
