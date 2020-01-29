% exc 2 - Sugeno para aproximar y=cos(x) [-pi/2, 3*pi/2]
clc; clf;

step = 0.001;

t = -1:step:1;
y = t.^2;

figure(1);
subplot(311);
plot(t,y,'b');
hold on;

p1 = [-1 , 1]; 
p2 = [ 0 , 0];
p3 = [ 1 , 1];   

[coeff1, S1] = polyfit([p1(1);p2(1)],[p1(2);p2(2)],1);
[coeff2, S2] = polyfit([p2(1);p3(1)],[p2(2);p3(2)],1);

y1 = polyval(coeff1,t);
y2 = polyval(coeff2,t);
plot(t,y1, 'r');
plot(t,y2, 'r');
axis ([-1 1 0 1]);

subplot(312);

% mf1 = trimf(t, [-pi/2 - pi,  -pi/2, -pi/2 + pi]);
% mf2 = trimf(t, [ pi/2 - pi,   pi/2,  pi/2 + pi]);
% mf3 = trimf(t, [3*pi/2- pi, 3*pi/2, 3*pi/2+ pi]);

a = pi;
mf1 = trimf(t, [-1, -1, 1]);
mf2 = trimf(t, [ -1, 1, 1]);

plot(t, mf1,'LineWidth',3);
hold on;
plot(t, mf2,'LineWidth',3);

legend('mf1', 'mf2');
axis ([-1 1 0 1]);

% graus de ativacao da regra nos consequentes
w1 = mf1 .* t;
w2 = mf2 .* t;

% z1 = coeff1(1)*t + coeff1(2);
% z2 = coeff2(1)*t + coeff2(2);
% z3 = coeff3(1)*t + coeff3(2);

z1 = y1;
z2 = y2;

sugeno = (w1.*z1 + w2.*z2)./(w1+w2);

subplot(313);
plot(t,sugeno,'r','LineWidth',1); hold on;
plot(t,y,'b','LineWidth',1);
legend('Sugeno','Real');
axis ([-1 1 0 1]);



%% 

exc3_sugeno = readfis('exc3_sugeno.fis');

t_seno = 0:0.01:2*pi;
y_seno = sin(t_seno);
y_hat = evalfis(t_seno,exc3_sugeno);
MSE = (sum((y_hat' - y_seno).^2))/size(y_seno,2)
figure();
plot(t,y_seno,'r'); hold on;
plot(t,y_hat,'b');
lengend()

%%
exc3_mamdani = seno_mamdani%readfis('seno_mamdani.fis');

t_seno = 0:0.01:2*pi;
y_seno = sin(t_seno);
y_hat = evalfis(t_seno,exc3_mamdani);
MSE = (sum((y_hat' - y_seno).^2))/size(y_seno,2)
figure();
plot(t,y_seno,'r'); hold on;
plot(t,y_hat,'b');
%lengend()


%% planes
P1 = [0,0,0];
P2 = [2.5,0,0.15];
P3 = [0,2.5,0.15];
normal = cross(P1-P2, P1-P3);

syms x y z;
P = [x,y,z];
planefunction = dot(normal, P-P1)
