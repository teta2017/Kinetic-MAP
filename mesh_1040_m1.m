clear all
clc
global a1 a2 R tspan Tfit tdat mOd mSd mGd has R2 m has2
global T IC

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
yy=has2;
R2has = R2;
result = [fteb fhas m R2];
errO=[abs(y(:,3)-mOd)];
errG=[abs(y(:,5)-mGd)];
errS=[abs(y(:,6)-mSd)];
err=[errO./mOd*100 errG./mGd.*100 errS./mSd.*100];
erm=[mean(err(:,1)) mean(err(:,2)) mean(err(:,3))];

Thasil=T;

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
g(3) = plot(tm,ym(:,4),'r-')
hold on
g(4) = plot(tdat,mGd,'r*')
hold on
g(5) = plot(tm,ym(:,5),'b-')
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

function f = fungsi2(z)
global A1 A2 A3 Ea1 Ea2 Ea3 tspan Tfit tdat mOd mSd mGd has n1 n2 n3 R2
global m has2 T IC
A1 = z(1);
A2 = z(2);
A3 = z(3);
Ea1 = z(4);
Ea2 = z(5);
Ea3 = z(6);
n1 = 1;
n2 = 1;
n3 = 1;

IC = [50 0 0 0 50 Tfit(1)];
[t,P] = ode15s(@fungsi,tspan,IC);
B = P(:,1);
O = P(:,2);
C = P(:,3);
G = P(:,4);
S = P(:,5);
T = P(:,6);
has2 = [tspan' B O C G S T];

%indexing
n = 1;
for m = tdat'
    ts(n) = find(tspan==m);
    Bi(n) = B(ts(n));
    Oi(n) = O(ts(n));
    Ci(n) = C(ts(n));
    Gi(n) = G(ts(n));
    Si(n) = S(ts(n));
    Ti(n) = T(ts(n));
    n = n+1;
end
has = [ts' Bi' Oi' Ci' Gi' Si' Ti'];

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
f = (f1i)+(f2i)+(f3i)
m = f;
R2=[1-f1i 1-f2i 1-f3i];
end

function dPdt = fungsi(~,P)
global a1 a2 A1 A2 A3 Ea1 Ea2 Ea3 R n1 n2 n3

mB = P(1);
mO = P(2);
mC = P(3);
mG = P(4);
mS = P(5);
T = P(6);

k1=A1.*exp(-Ea1./R.*(1./T));
k2=A2.*exp(-Ea2./R.*(1./T));
k3=A3.*exp(-Ea3./R.*(1./T));

dmBdt = -(k1.*mB.^n1+k2.*mB.^n2+k3.*mB.^n3);
dmOdt = k1.*mB.^n1;
dmCdt = k2.*mB.^n2;
dmGdt = k3.*mB.^n3;
dmSdt = dmCdt+dmBdt;

if T < 337
    dTdt = a1;
elseif T >= 337 && T < 723
    dTdt = a2;
else
    dTdt = 0;
end
dPdt = [dmBdt dmOdt dmCdt dmGdt dmSdt dTdt]';
end