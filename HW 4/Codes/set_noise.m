function [w, v]=set_noise(Q,R,N) 
    w = sqrtm(Q)*randn(size(Q,1), N);
    v = sqrtm(R)*randn(size(R,1), N);
end