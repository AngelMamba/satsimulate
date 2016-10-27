function [ dq ] = satkinematics( t, q, wib, wio )
%SATKINEMATICS Summary of this function goes here
%   Detailed explanation goes here
%q Ϊ������ 1*4
%wio Ϊ������ 1*3
%dq Ϊ������ 4*1

% wio = [wio 0];
    wib = reshape(wib, 1, 3);
    wio = reshape(wio, 1, 3);%��֤��ʽ��ȷ
    w = wib - (calcC(q) * wio')';
    w = [w 0];
    dq = 0.5 * quatmultiply(q', w)';

end