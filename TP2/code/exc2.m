% exc 2 - Sugeno para aproximar y=cos(x) [-pi/2, 3*pi/2]
clc; clf;

step = 0.01;

t_cos = -pi/2:step:3*pi/2;
y_cos = cos(t_cos);

figure(1);
subplot(311);
plot(t_cos,y_cos,'b');
hold on;

p1 = [-pi/2 , 0]; 
p2 = [0     , 1];     
p3 = [pi    ,-1];   
p4 = [3*pi/2, 0];

[coeff1, S1] = polyfit([p1(1);p2(1)],[p1(2);p2(2)],1);
[coeff2, S2] = polyfit([p2(1);p3(1)],[p2(2);p3(2)],1);
[coeff3, S3] = polyfit([p3(1);p4(1)],[p3(2);p4(2)],1);

y1 = polyval(coeff1,t_cos);
y2 = polyval(coeff2,t_cos);
y3 = polyval(coeff3,t_cos);
plot(t_cos,y1, 'r');
plot(t_cos,y2, 'r');
plot(t_cos,y3, 'r');
axis ([-pi/2 3*pi/2 -1 1]);

subplot(312);

% mf1 = trimf(t, [-pi/2 - pi,  -pi/2, -pi/2 + pi]);
% mf2 = trimf(t, [ pi/2 - pi,   pi/2,  pi/2 + pi]);
% mf3 = trimf(t, [3*pi/2- pi, 3*pi/2, 3*pi/2+ pi]);

a = pi;
mf1 = trimf(t_cos, [-pi/2 - pi,  -pi/2, -pi/2 + pi]);
mf2 = trimf(t_cos, [ pi/2 - pi,   pi/2,  pi/2 + pi]);
mf3 = trimf(t_cos, [3*pi/2- pi, 3*pi/2, 3*pi/2+ pi]);

plot(t_cos, mf1,'LineWidth',3);
hold on;
plot(t_cos, mf2,'LineWidth',3);
plot(t_cos, mf3,'LineWidth',3);
legend('mf1', 'mf2', 'mf3');
axis ([-pi/2 3*pi/2 0 1]);

% graus de ativacao da regra nos consequentes
w1 = mf1 .* t_cos;
w2 = mf2 .* t_cos;
w3 = mf3 .* t_cos;

% z1 = coeff1(1)*t + coeff1(2);
% z2 = coeff2(1)*t + coeff2(2);
% z3 = coeff3(1)*t + coeff3(2);

z1 = y1;
z2 = y2;
z3 = y3;

sugeno = (w1.*z1 + w2.*z2 + w3.*z3)./(w1+w2+w3);

subplot(313);
plot(t_cos,sugeno,'r','LineWidth',1); hold on;
plot(t_cos,y_cos,'b','LineWidth',1);
legend('Sugeno','Real');
axis ([-pi/2 3*pi/2 -1 1]);



%% 

exc3_sugeno = readfis('exc3_sugeno.fis');

t_seno = 0:0.01:2*pi;
y_seno = sin(t_seno);
y_hat = evalfis(t_seno,exc3_sugeno);
MSE = (sum((y_hat' - y_seno).^2))/size(y_seno,2)
figure();
plot(t_cos,y_seno,'r'); hold on;
plot(t_cos,y_hat,'b');
lengend()

%%
exc3_mamdani = seno_mamdani%readfis('seno_mamdani.fis');

t_seno = 0:0.01:2*pi;
y_seno = sin(t_seno);
y_hat = evalfis(t_seno,exc3_mamdani);
MSE = (sum((y_hat' - y_seno).^2))/size(y_seno,2)
figure();
plot(t_cos,y_seno,'r'); hold on;
plot(t_cos,y_hat,'b');
%lengend()


%% planes
P1 = [0,0,0];
P2 = [2.5,0,0.15];
P3 = [0,2.5,0.15];
normal = cross(P1-P2, P1-P3);

syms x y z;
P = [x,y,z];
planefunction = dot(normal, P-P1)
