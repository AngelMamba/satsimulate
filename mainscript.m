clear;
clc;

format long;
I = [1.25 0 0;0 9.65 0;0 0 9.65];
T = [0; 0; 0];
d2r = pi/180;
w0 = [0.1;0.1;0.1]*d2r;
angle0 = [0 42.7 5.6] * d2r;
q0 = angle2quat(angle0(3), angle0(2), angle0(1), 'ZYX');
anglet = [10 10 30] * d2r;
qt = angle2quat(anglet(3), anglet(2), anglet(1), 'ZYX');
wio = [0 -2*pi/5431.184 0]; %������ٶ� height = 300km
drift = [1 1 1] * 0.5/3600*d2r;
noig = [1 1 1] * 1/3 * 5 * 10 ^(-5) * d2r;
PDw = [5 5 5];%PIDȨ��
Kp = [I(1,1)/0.515*PDw(1)^2*0.6 I(2,2)/3.18*PDw(2)^2*0.6 I(3,3)/1.59*PDw(3)^2*0.6]*2;
Kd = [4*PDw(1)*I(1,1)/0.515, 2*PDw(2)*I(2,2)/3.18, 4*PDw(3)*I(3,3)/1.59]*sqrt(0.6);
t0 = 0;
dt = 0.05;
tf = 10;

try
    stkClose(conid);
    stkClose();
catch ME
    disp('stkClose Message');
end
satPath = '*/Satellite/Satellite1';
scenario = 'Scenario/test2';
cb = 'Earth';
stkInit;%ȷ��stk�Ѿ���
conid = stkOpen(stkDefaultHost);
stkExec(conid, ['Animate ' scenario ' Reset']);
stkExec(conid, ['SetAnimation ' scenario ' TimeStep ' num2str(dt)]);
stkSetAttitudeCBI(satPath, cb, 0, q0');

i = 0;
wib = w0;
q = q0;
xmem = zeros(length(t0:dt:tf),10);
for t = t0:dt:tf
    i = i+1;
    disp(i);
    wib = reshape(wib,3,1);
    q = reshape(q,4,1);
    qe = satTarget(q, qt);
    wob = wib2wob(wib, q, wio);
    T = attiControl(wob, qe, Kd, Kp);
    Tmem = reshape(T,1,3);
    x0 = [wib;q];
    [tout, xout] = ode23tb(@satbody, [t t+dt], x0, odeset(), T, I, wio, satPath, dt);
    wib = xout(end, 1:3);
    q = xout(end, 4:7);
   stkSetAttitudeCBI(satPath, cb, t+dt, q');
   stkExec(conid, ['Animate ' scenario ' Step Forward']);
    xmem(i,1:7) = xout(end,:);
    xmem(i,8:10) = Tmem;
end