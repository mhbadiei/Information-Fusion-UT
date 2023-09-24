function [f, h]=set_functions
    f = inline('xt+Ts*[xt(2);(u*cos(xt(1))-(M+m)*g*sin(xt(1))+ m*l*(cos(xt(1)))*(sin(xt(1)))*xt(2)*xt(2))/(m*l*(cos(xt(1)))*cos(xt(1))-(M+m)*l);xt(4);(u+m*l*(sin(xt(1)))*(xt(2)*xt(2))-m*g*sin(xt(1))*cos(xt(1)))/(M+m-m*cos(xt(1))*cos(xt(1)))];','xt','u','m','M','g','l','k','Ts');
    h = inline('[1 0 0 0;0 0 1 0]*xt','xt');
end