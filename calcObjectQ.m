function [ axis,q] = calcObjectQ( target, constraint )
%CALCOBJECTQ Summary of this function goes here
%   ����Ŀ�����ʱ��Ŀ����̬��Ԫ������x�����̫��(target)����z��ָ����������Ϊ��
    target = target/norm(target);
    constraint = constraint/norm(constraint);
    n = cross(target, constraint);%target,constraint����ƽ��ķ���
    axis_z = zeros(1, 3);%���ݵ㷨ʽ������Z��
    axis_z(1) = 1;
    axis_z(2) = (n(1)*target(3)-n(3)*target(1))/(n(3)*target(2)-n(2)*target(3));
    axis_z(3) = (n(1)*target(2)-n(2)*target(1))/(n(2)*target(3)-n(3)*target(2));
    if dot(constraint, axis_z) < 0%��֤Z���������ͬ����
        axis_z = -axis_z;
    end
    axis_z = axis_z/norm(axis_z);
    axis_y = cross(axis_z, target);%z���x��Ĳ�˾���y��
    axis = [target; axis_y; axis_z];
    A = axis*eye(3);
    
    q = dcm2quat(A);
end