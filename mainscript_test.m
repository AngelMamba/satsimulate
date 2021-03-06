clear;
clc;

format long;
I = [1.25 0 0;0 9.65 0;0 0 9.65];
T = [0; 0; 0];
% w0 = [0.17;0.17;0.17];
d2r = pi/180;
w0 = [0.1;0.1;0.1] * d2r;
angle0 = [0 42.7 5.6] * d2r;
q0 = angle2quat(angle0(3), angle0(2), angle0(1), 'ZYX');
anglet = [10 10 30] * d2r;
qt = angle2quat(anglet(3), anglet(2), anglet(1), 'ZYX');
wio = [0 -2*pi/5431.184 0]; %轨道角速度 height = 300km
drift = [1 1 1] * 0.5/3600*d2r;
noig = [1 1 1] * 1/3 * 5 * 10 ^(-5) * d2r;
PDw = [5 5 5];%PID权重
Kp = [I(1,1)/0.515*PDw(1)^2*0.6 I(2,2)/3.18*PDw(2)^2*0.6 I(3,3)/1.59*PDw(3)^2*0.6]*2;
Kd = [4*PDw(1)*I(1,1)/0.515, 2*PDw(2)*I(2,2)/3.18, 4*PDw(3)*I(3,3)/1.59]*sqrt(0.6);

t0 = 0;
dt = 0.05;

% [tout,wout] = ode23tb(@satdynamic, [t0 tt], w0, odeset(), I, T);

episode = 200;
i = 0;
wib = w0;
q = q0;
xmem = zeros(episode,10);
while i < episode
    wib = reshape(wib,3,1);
    q = reshape(q,4,1);
    qe = satTarget(q, qt);
    wob = wib2wob(wib, q, wio);
    T = attiControl(wib, qe, Kd, Kp);
    Tmem = reshape(T,1,3);
    T = [0.01;0.02;0.03];
    x0 = [wib;q];
    [tout, xout] = ode23tb(@satbody, [t0 dt], x0, odeset(), T, I, wio);
    wib = xout(end, 1:3);
    q = xout(end, 4:7);
    i = i+1;
    xmem(i,1:7) = xout(end,:);
    xmem(i,8:10) = reshape(wob,3,1);
%     xmem(i,8:10) = Tmem;
%     q(1) = sqrt(abs(1 - sum(q(2:4).^2)));%减少累计误差
end