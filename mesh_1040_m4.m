clear all
clc
global a1 a2 R tspan Tfit tdat mOd mSd mGd has R2 Sf
global has2 dmSdt dmOdt dmGdt m IC

%ukuran 10-40 mesh
%ini model farag
mOd = xlsread('Data Conference 2','Sheet3','B31:B41');
mSd = xlsread('Data Conference 2','Sheet3','F31:F41');
mGd = xlsread('Data Conference 2','Sheet3','G31:G41');
Tdat = xlsread('Data Conference 2','Sheet3','H31:H41');
tdat = xlsread('Data Conference 2','Sheet3','A31:A41');

%untuk fitting suhu
Tfit = xlsread('Data Conference 2','Sheet2','H1:H41');
nt = 41;
tspan = linspace(0,20,nt);
R = 8.3145;
Sf = mSd(end)-5.898;

%dTdt 1
T1 = Tfit(1:3);
t1 = tspan(1:3)';
dTdt1 = polyfit(t1,T1,1);
a1 = dTdt1(1);
b1 = dTdt1(2);

%dTdt 2
T2 = Tfit(4:14);
t2 = tspan(4:14)';
dTdt2= polyfit(t2,T2,1);
a2 = dTdt2(1);
b2 = dTdt2(2);

optN = optimset('MaxFunEvals',1e7,'MaxIter',1e5);
fteb = [0.5 0.5 0.5 1000 1000 1000];
fhas = fminsearch(@fungsi2,fteb,optN);

y = has;
yy = has2;
R2has = R2;
result = [fteb fhas m R2];

steb = [0.1 1000];
shas = fminsearch(@fungsi3,steb);
dmdt = [dmSdt dmOdt dmGdt];

%matriks hasil perhitungan
ym = zeros(length(mOd)+1,6);
ym(1,:) = IC;
ym(2:length(mOd)+1,1)=y(:,2);
ym(2:length(mOd)+1,2)=y(:,3);
ym(2:length(mOd)+1,3)=y(:,4);
ym(2:length(mOd)+1,4)=y(:,5);
ym(2:length(mOd)+1,5)=y(:,6);
ym(2:length(mOd)+1,6)=y(:,7);
tm = [0;tdat];

figure(1)
g(1) = plot(tm,ym(:,2),'k-')
hold on
g(2) = plot(tdat,mOd,'k*')
hold on
g(3) = plot(tm,ym(:,3),'r-')
hold on
g(4) = plot(tdat,mGd,'r*')
hold on
g(5) = plot(tm,ym(:,1),'b-')
hold on
g(6) = plot(tdat,mSd,'b*')
hold off
xlabel('Time, minute','FontName','Arial','FontSize',14)
ylabel('Yield, gram','FontName','Arial','FontSize',14)
ss=legend(g,'bio-oil (calc)','bio-oil (exp)','gas (calc)','gas (exp)',...
'remaining solid (calc)','remaining solid (exp)')
set(ss,'FontSize',12.5)
set(gcf,'position',[10,10,500,500])
h=gca;
h.XAxis.MinorTick='on';
h.XAxis.MinorTickValues=0:1:20;

function f = fungsi3(k)
global AS EaS tdat tspan Si Tfit
AS = k(1);
EaS = k(2);

IC=[50 Tfit(1)];
[t,P]=ode45(@fungsi4,tspan,IC);
S = P(:,1);
T = P(:,2);

%indexing
n = 1;
for j = tdat'
    tsi(n) = find(tspan==j);
    Sii(n) = S(tsi(n));
    Tii(n) = T(tsi(n));
    n = n+1;
end
%has = [tsi' Sii' Oi' Gi' Bi' Ci' Tii'];

for i = 1:length(tdat)
    f3(i)=(Sii(i)-Si(i)).^2;
    f3a(i)=(mean(Si)-Si(i)).^2;
end
f3i = sum(f3)./sum(f3a);
f = f3i;

end

function dPdt = fungsi4(t,P)
global nS1 AS EaS R Sf a1 a2
mS = P(1);
T = P(2);
kS = AS.*exp(-EaS./R./T);
dSdt = -kS.*(mS-Sf).^nS1;
if T < 337
    dTdt = a1;
elseif T >= 337 && T < 723
    dTdt = a2;
else
    dTdt = 0;
end
dPdt = [dSdt dTdt]';
end

function f = fungsi2(z)
global AL AG1 AG2 EaL EaG1 EaG2 tspan Tfit tdat mOd mSd mGd has nL R2
global has2 m nG1 nG2 Si nS1 IC

AL = z(1);
AG1 = z(2);
AG2 = z(3);
EaL = z(4);
EaG1 = z(5);
EaG2 = z(6);
nL = 1;
nG1 = 1;
nG2 = 1;
nS1 = 1;

IC = [50 0 0 50 0 Tfit(1)];
[t,P] = ode15s(@fungsi,tspan,IC);
S = P(:,1);
O = P(:,2);
G = P(:,3);
B = P(:,4);
C = P(:,5);
T = P(:,6);
has2 = [tspan' S O G B C T];

%indexing
n = 1;
for m = tdat'
    ts(n) = find(tspan==m);
    Si(n) = S(ts(n));
    Oi(n) = O(ts(n));
    Gi(n) = G(ts(n));
    Bi(n) = B(ts(n));
    Ci(n) = C(ts(n));
    Ti(n) = T(ts(n));
    n = n+1;
end
has = [ts' Si' Oi' Gi' Bi' Ci' Ti'];

for i = 1:length(tdat)
    f1(i)=(Oi(i)-mOd(i)).^2;
    f1a(i)=(mean(mOd)-mOd(i)).^2;
    f2(i)=(Gi(i)-mGd(i)).^2;
    f2a(i)=(mean(mGd)-mGd(i)).^2;
    f3(i)=(Si(i)-mSd(i)).^2;
    f3a(i)=(mean(mSd)-mSd(i)).^2;
    f4(i)=(Ti(i)-Tfit(i)).^2;
end
f1i = sum(f1)./sum(f1a);
f2i = sum(f2)./sum(f2a);
f3i = sum(f3)./sum(f3a);
f = sum(f1i)+sum(f2i)+sum(f3i)
m=f;
R2=[1-f1i 1-f2i 1-f3i];
end

function dPdt = fungsi(~,P)
global a1 a2 AL AG1 AG2 EaL EaG1 EaG2 R nL nG1 nG2
global Sf dmSdt dmOdt dmGdt

mS = P(1);
mO = P(2);
mG = P(3);
mB = P(4);
mC = P(5);
T = P(6);

kL=AL.*exp(-EaL./R.*(1./T));
kG1=AG1.*exp(-EaG1./R.*(1./T));
kG2=AG2.*exp(-EaG2./R.*(1./T));

dmSdt = -kL.*(mS-Sf).^nL-kG1.*(mS-Sf).^nG1;
dmOdt = kL.*(mS-Sf).^nL-kG2.*(mS-Sf).^nG2;
dmGdt = kG1.*(mS-Sf).^nG1+kG2.*(mS-Sf).^nG2;

if mB > 0.01
    dmBdt = dmSdt-dmOdt-dmGdt;
else
    dmBdt = 0;
end
dmCdt = dmSdt-dmBdt;
if T < 337
    dTdt = a1;
elseif T >= 337 && T < 723
    dTdt = a2;
else
    dTdt = 0;
end
dPdt = [dmSdt dmOdt dmGdt dmBdt dmCdt dTdt]';
end