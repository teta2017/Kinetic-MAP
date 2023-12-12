clear all
clc
d1=xlsread('Data Conference 3','Kesimpulan','B3:I6'); %10-40
d2=xlsread('Data Conference 3','Kesimpulan','B10:I13'); %40-70
d3=xlsread('Data Conference 3','Kesimpulan','B17:I20'); %70-100
d4=xlsread('Data Conference 3','Kesimpulan','B24:I27'); %>100
A1=[d1(:,1);d2(:,1);d3(:,1);d4(:,1)];
A2=[d1(:,2);d2(:,2);d3(:,2);d4(:,2)];
A3=[d1(:,3);d2(:,3);d3(:,3);d4(:,3)];
A4=[d1(:,4);d2(:,4);d3(:,4);d4(:,4)];
Ea1=[d1(:,5);d2(:,5);d3(:,5);d4(:,5)];
Ea2=[d1(:,6);d2(:,6);d3(:,6);d4(:,6)];
Ea3=[d1(:,7);d2(:,7);d3(:,7);d4(:,7)];
Ea4=[d1(:,8);d2(:,8);d3(:,8);d4(:,8)];
A=[A1 A2 A3 A4];
Ea=[Ea1 Ea2 Ea3 Ea4];
R=8.3145;
T=310:1:723;
TC = T;
s=length(A1);
%i=suhu, j=model, m=produk
%i=suhu
%j=model
%model 1: 1,5,9,13; model 2: 2,6,10,14;
%model 3: 3,7,11,15; model 4: 4,8,12,16;
%m=produk(bio-oil, rs/char, gas, gas)
for m = 1:4
    for i = 1:length(T)
        for j = 1:length(A1)
            k(i,j,m)=A(j,m).*exp(-Ea(j,m)./R./T(i));
        end
    end
end
figure(1)
g(1) = plot(TC,k(:,2,1),'b','Linewidth',0.85)
hold on
g(2) = plot(TC,k(:,2,2),'r','Linewidth',0.85)
hold on
g(3) = plot(TC,k(:,2,3),'k','Linewidth',0.85)
hold on
g(4) = plot(TC,k(:,2,4),'m','Linewidth',0.85)
hold off
legend(g,'kL','kC','kG1','kG2','Location',...
    'SouthOutside','Orientation','Horizontal')
xlabel('T, K','FontName','Arial','FontSize',14)
ylabel('k, 1/min','FontName','Arial','FontSize',14)
xlim([300 750])
set(gcf,'position',[10,10,500,500])
set(legend,'FontSize',12.5)

figure(2)
g(1) = plot(TC,k(:,6,1),'b','Linewidth',0.85)
hold on
g(2) = plot(TC,k(:,6,2),'r','Linewidth',0.85)
hold on
g(3) = plot(TC,k(:,6,3),'k','Linewidth',0.85)
hold on
g(4) = plot(TC,k(:,6,4),'m','Linewidth',0.85)
hold off
legend(g,'kL','kC','kG1','kG2','Location',...
    'SouthOutside','Orientation','Horizontal')
xlabel('T, K','FontName','Arial','FontSize',14)
ylabel('k, 1/min','FontName','Arial','FontSize',14)
xlim([300 750])
set(gcf,'position',[10,10,500,500])
set(legend,'FontSize',12.5)

figure(3)
g(1) = plot(TC,k(:,10,1),'b','Linewidth',0.85)
hold on
g(2) = plot(TC,k(:,10,2),'r','Linewidth',0.85)
hold on
g(3) = plot(TC,k(:,10,3),'k','Linewidth',0.85)
hold on
g(4) = plot(TC,k(:,10,4),'m','Linewidth',0.85)
hold off
legend(g,'kL','kC','kG1','kG2','Location',...
    'SouthOutside','Orientation','Horizontal')
xlabel('T, K','FontName','Arial','FontSize',14)
ylabel('k, 1/min','FontName','Arial','FontSize',14)
xlim([300 750])
set(gcf,'position',[10,10,500,500])
set(legend,'FontSize',12.5)

figure(4)
g(1) = plot(TC,k(:,14,1),'b','Linewidth',0.85)
hold on
g(2) = plot(TC,k(:,14,2),'r','Linewidth',0.85)
hold on
g(3) = plot(TC,k(:,14,3),'k','Linewidth',0.85)
hold on
g(4) = plot(TC,k(:,14,4),'m','Linewidth',0.85)
hold off
legend(g,'kL','kC','kG1','kG2','Location',...
    'SouthOutside','Orientation','Horizontal')
xlabel('T, K','FontName','Arial','FontSize',14)
ylabel('k, 1/min','FontName','Arial','FontSize',14)
xlim([300 750])
set(gcf,'position',[10,10,500,500])
set(legend,'FontSize',12.5)

figure(5)
g(1) = plot(TC,k(:,4,1),'b','Linewidth',0.85)
hold on
g(2) = plot(TC,k(:,4,2),'r','Linewidth',0.85)
hold on
g(3) = plot(TC,k(:,4,3),'k','Linewidth',0.85)
hold on
g(4) = plot(TC,k(:,4,4),'m','Linewidth',0.85)
hold off
legend(g,'kL','kS','kG1','kG2','Location',...
    'SouthOutside','Orientation','Horizontal')
xlabel('T, K','FontName','Arial','FontSize',14)
ylabel('k, 1/min','FontName','Arial','FontSize',14)
xlim([300 750])
set(gcf,'position',[10,10,500,500])
set(legend,'FontSize',12.5)

figure(6)
g(1) = plot(TC,k(:,8,1),'b','Linewidth',0.85)
hold on
g(2) = plot(TC,k(:,8,2),'r','Linewidth',0.85)
hold on
g(3) = plot(TC,k(:,8,3),'k','Linewidth',0.85)
hold on
g(4) = plot(TC,k(:,8,4),'m','Linewidth',0.85)
hold off
legend(g,'kL','kS','kG1','kG2','Location',...
    'SouthOutside','Orientation','Horizontal')
xlabel('T, K','FontName','Arial','FontSize',14)
ylabel('k, 1/min','FontName','Arial','FontSize',14)
xlim([300 750])
set(gcf,'position',[10,10,500,500])
set(legend,'FontSize',12.5)

figure(7)
g(1) = plot(TC,k(:,12,1),'b','Linewidth',0.85)
hold on
g(2) = plot(TC,k(:,12,2),'r','Linewidth',0.85)
hold on
g(3) = plot(TC,k(:,12,3),'k','Linewidth',0.85)
hold on
g(4) = plot(TC,k(:,12,4),'m','Linewidth',0.85)
hold off
legend(g,'kL','kS','kG1','kG2','Location',...
    'SouthOutside','Orientation','Horizontal')
xlabel('T, K','FontName','Arial','FontSize',14)
ylabel('k, 1/min','FontName','Arial','FontSize',14)
xlim([300 750])
set(gcf,'position',[10,10,500,500])
set(legend,'FontSize',12.5)

figure(8)
g(1) = plot(TC,k(:,16,1),'b','Linewidth',0.85)
hold on
g(2) = plot(TC,k(:,16,2),'r','Linewidth',0.85)
hold on
g(3) = plot(TC,k(:,16,3),'k','Linewidth',0.85)
hold on
g(4) = plot(TC,k(:,16,4),'m','Linewidth',0.85)
hold off
legend(g,'kL','kS','kG1','kG2','Location',...
    'SouthOutside','Orientation','Horizontal')
xlabel('T, K','FontName','Arial','FontSize',14)
ylabel('k, 1/min','FontName','Arial','FontSize',14)
xlim([300 750])
set(gcf,'position',[10,10,500,500])
set(legend,'FontSize',12.5)