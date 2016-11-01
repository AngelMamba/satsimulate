function [ dq ] = satkinematics( t, q, wib, wio )
%SATKINEMATICS Summary of this function goes here
%   Detailed explanation goes here
%q Ϊ������ 1*4
%wio Ϊ������ 1*3
%dq Ϊ������ 4*1

q = reshape(q,1,4);

% wio = [wio 0];
    w = wib2wob(wib, q, wio);
    w = [w 0];
    dq = 0.5 * quatmultiply(q, w)';

end