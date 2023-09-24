close;
clear;
clc;

%% Definition of variable lambda
syms x

%% Part 1-a
C = coeffs(expand((1+0.3*x)*(1+0.6*x)*(1+0.7*x)*(1+0.3*x) - x - 1),'All');
digits(6)
r = vpa(roots(C));

%% Part 1-b

C_b = coeffs(expand((1+0.3*x)*(1+0.6*x) - x - 1),'All');
digits(6)
r_b = vpa(roots(C_b));

%% Part 1-c

C_c = coeffs(expand((1+0.7*x)*(1+0.3*x) - x - 1),'All');
digits(6)
r_c = vpa(roots(C_c));

%% Part 1-c

C_d = coeffs(expand((1+0.6*x)*(1+0.7*x) - x - 1),'All');
digits(6)
r_d = vpa(roots(C_d));
