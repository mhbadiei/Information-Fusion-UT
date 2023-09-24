function xHat=PF(N, Ts, m, M, g, l, P, Q, R, u, x0, xStateInit, w, v)

xState(:,1) = xStateInit;
xHat = x0;

[f, h]=set_functions;
pe = inline('(1)*exp(-(1/2)*(sum(e.*(inv([1.2,0;0,0.8])*e))))');

for k=1:N-1
xState(:,k+1) = feval(f,xState(:,k),u,m,M,g,l,k,Ts) + w(:,k);
y(:,k) = feval(h,xState(:,k)) + v(:,k);
end
xHat = [xHat,PF_FCN(f,h,pe,Q,x0,P,100,y,u,m,M,g,l,Ts,w,v)];
end