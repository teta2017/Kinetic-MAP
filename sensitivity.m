clear all
clc
global a1 a2 A1 A2 A3 A4 Ea1 Ea2 Ea3 Ea4 R n1 n2 n3 n4
global A12 A22 A32 A42 Ea12 Ea22 Ea32 Ea42
global A13 A23 A33 A43 Ea13 Ea23 Ea33 Ea43
global A14 A24 A34 A44 Ea14 Ea24 Ea34 Ea44

data=xlsread('Data Conference 3','Kesimpulan','B3:I3');
A1=data(1).*1.25;
A2=data(2).*1;
A3=data(3).*1;
Ea1=data(5).*1;
Ea2=data(6).*1;
Ea3=data(7).*1;
n1=1; n2=1; n3=1; n4=1;

A12=data(1).*1;
A22=data(2).*1.25;
A32=data(3).*1;
Ea12=data(5).*1;
Ea22=data(6).*1;
Ea32=data(7).*1;

A13=data(1).*1;
A23=data(2).*1;
A33=data(3).*1.25;
Ea13=data(5).*1;
Ea23=data(6).*1;
Ea33=data(7).*1;

%ukuran 10-40 mesh
dat=xlsread('Data Conference 4','1040_m1','A2:G42');
ti=dat(:,1);
mBd=dat(:,2);
mOd=dat(:,3);
mCd=dat(:,4);
mGd=dat(:,5);
mSd=dat(:,6);
Ti=dat(:,7);

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

IC = [50 0 0 0 50 Tfit(1)];
[t,P]=ode15s(@fungsi,tspan,IC); %+25
[t2,P2]=ode15s(@fungsi2,tspan,IC); %+50
[t3,P3]=ode15s(@fungsi3,tspan,IC); %-25
B = P(:,1);O = P(:,2);C = P(:,3);G = P(:,4);S = P(:,5);T = P(:,6);
B2 = P2(:,1);O2 = P2(:,2);C2 = P2(:,3);G2 = P2(:,4);S2 = P2(:,5);T2 = P2(:,6);
B3 = P3(:,1);O3 = P3(:,2);C3 = P3(:,3);G3 = P3(:,4);S3 = P3(:,5);T3 = P3(:,6);

errO1=abs(mOd-O)./mOd.*100;
errO2=abs(mOd-O2)./mOd.*100;
errO3=abs(mOd-O3)./mOd.*100;
errS1=abs(mSd-S)./mSd.*100;
errS2=abs(mSd-S2)./mSd.*100;
errS3=abs(mSd-S3)./mSd.*100;
errG1=abs(mGd-G)./mGd.*100;
errG2=abs(mGd-G2)./mGd.*100;
errG3=abs(mGd-G3)./mGd.*100;

err=[mean(errO1(2:end)) mean(errO2(2:end)) mean(errO3(2:end));
    mean(errS1(2:end)) mean(errS2(2:end)) mean(errS3(2:end));
    mean(errG1(2:end)) mean(errG2(2:end)) mean(errG3(2:end))];

figure(1)
g(1)=plot(t,mOd,'k-','linewidth',1.25)
hold on
g(2)=plot(t,O,'r-','linewidth',0.75)
hold on
g(3)=plot(t,O2,'b-','linewidth',0.75)
hold on
g(4)=plot(t,O3,'color',[1 0.647 0],'linewidth',0.75)
hold off
legend(g,'+0%','A1 +25%','A2 +25%','A3 +25%','location','southeast')
xlabel('Time, min','FontSize',14)
ylabel('Bio-oil yield, gram','FontSize',14)
set(legend,'FontSize',14)
set(gcf,'position',[10,10,500,500])

figure(2)
h(1)=plot(t,mSd,'k-','linewidth',1.25)
hold on
h(2)=plot(t,S,'r-','linewidth',0.75)
hold on
h(3)=plot(t,S2,'b-','linewidth',0.75)
hold on
h(4)=plot(t,S3,'color',[1 0.647 0],'linewidth',0.75)
hold off
legend(h,'+0%','A1 +25%','A2 +25%','A3 +25%','location','northeast')
xlabel('Time, min','FontSize',14)
ylabel('Remaining solid yield, gram','FontSize',14)
set(legend,'FontSize',14)
set(gcf,'position',[10,10,500,500])

figure(3)
i(1)=plot(t,mGd,'k-','linewidth',1.25)
hold on
i(2)=plot(t,G,'r-','linewidth',0.75)
hold on
i(3)=plot(t,G2,'b-','linewidth',0.75)
hold on
i(4)=plot(t,G3,'color',[1 0.647 0],'linewidth',0.75)
hold off
legend(i,'+0%','A1 +25%','A2 +25%','A3 +25%','location','southeast')
xlabel('Time, min','FontSize',14)
ylabel('Gas yield, gram','FontSize',14)
set(legend,'FontSize',14)
set(gcf,'position',[10,10,500,500])

function dPdt = fungsi(~,P)
global a1 a2 A1 A2 A3 Ea1 Ea2 Ea3 R n1 n2 n3 n4
global A4 Ea4

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

function dPdt = fungsi3(~,P)
global a1 a2 A13 A23 A33 Ea13 Ea23 Ea33 R n1 n2 n3 n4
global A43 Ea43

mB = P(1);
mO = P(2);
mC = P(3);
mG = P(4);
mS = P(5);
T = P(6);

k1=A13.*exp(-Ea13./R.*(1./T));
k2=A23.*exp(-Ea23./R.*(1./T));
k3=A33.*exp(-Ea33./R.*(1./T));

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

function dPdt = fungsi2(~,P)
global a1 a2 A12 A22 A32 Ea12 Ea22 Ea32 R n1 n2 n3 n4
global A42 Ea42

mB = P(1);
mO = P(2);
mC = P(3);
mG = P(4);
mS = P(5);
T = P(6);

k1=A12.*exp(-Ea12./R.*(1./T));
k2=A22.*exp(-Ea22./R.*(1./T));
k3=A32.*exp(-Ea32./R.*(1./T));

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