function [ wob ] = wib2wob( wib, q, wio )
%WIB2WOB Summary of this function goes here
%   Detailed explanation goes here
    wib = reshape(wib, 1, 3);
    wio = reshape(wio, 1, 3);%��֤��ʽ��ȷ
    wob = wib - (calcC(q) * wio')';

end

