function [ wob_m ] = satGyro( wob, drift, noig )
%SATGYRO Summary of this function goes here
%   Detailed explanation goes here ������ά���� ��Ҫ��Ӿ���ģ��
%wob Ϊ������ 1*3
%drift Ϊ��������Ư�� 1*3
%noig Ϊ��˹������ϵ��
    wob_m = wob + drift + noig*rand([1,3]);
end