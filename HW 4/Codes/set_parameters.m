function [N, Ts, m, M, g, l, P, Q, R, u, x0, xStateInit] = set_parameters
    N = 10001;
    Ts = 0.001;
    m = 0.23;
    M = 2.4;
    g = 9.81;
    l = 0.36;
    P = eye(4);
Q = [0.9 , 0 , 0 , 0 ;
     0 , 0.8 , 0 , 0 ;
     0 , 0 , 0.9 , 0 ;
     0 , 0 , 0 , 0.8];
 R = [1.2 , 0 ;
      0 , 0.8]; 
    u = -0.2 + (0.4)*rand(1);
    x0 = [0.25 0.25 0.25 0.25]';
    xStateInit = [0.1 0.1 0.1 0.1]';
end