function [ h ] = PlotResults(d, times, Qepa, Hepa, Qlower, Qupper, hlower, hupper)
%% create x-axis time table
time=0:size(Qlower,2)-1;
fontsize=12;
% d.plot
%% Leakage
leakTime=12;

%% Flow and pressure bounds
pipenum=size(Qlower,1);
plotperfig =3;
for j=1:ceil(pipenum/plotperfig)
figure('units','normalized','outerposition',[0 0 0.95 1])
for i=1:plotperfig
% pipe=i+(j-1)*plotperfig;
switch i
    case 1; 
        pipe=1;
    case 2
        pipe=5;
    case 3
        pipe=10;
end  
if pipe>pipenum; break; end
subplot(3,3,i)
plot(time,Qepa(pipe,:),'k','linewidth',1.5)
set(gca,'fontsize',fontsize)
hold all
jbfill(time,Qlower(pipe,:),Qupper(pipe,:),'b','b');
title(['Water flow in pipe ',num2str(pipe)])
xlabel('Time (Hours)')
ylabel('Flow (m^3/ h)')
axis tight
% legend('EPANET flow', 'IHISE flow bounds')
% grid on
Y=get(gca,'ylim');
X=[leakTime leakTime];
h=line(X,Y,'Color','r','LineWidth',1);
end
keyboard
end

%%
elevations = d.getNodeElevations;
nodenum=size(hlower,1);
plotperfig =9;
for j=1:ceil(nodenum/plotperfig)
figure('units','normalized','outerposition',[0 0 0.95 1])
for i=1:plotperfig
node=i+(j-1)*plotperfig;
if node>nodenum; break; end
subplot(3,3,i)
plot(time,Hepa(node,:)-elevations(node),'k','linewidth',1.5)
set(gca,'fontsize',fontsize)
hold all
jbfill(time,hlower(node,:)-elevations(node),hupper(node,:)-elevations(node),'r','r');
title(['Head at node ',num2str(node)])
xlabel('Time (Hours)')
ylabel('Pressure Head (m)')
axis tight
% legend('EPANET head', 'IHISE head bounds')
grid on
end
keyboard
end

% %% Flow and pressure bounds second review
% pipenum=size(Qlower,1);
% plotperfig =6;
% figure('units','normalized','outerposition',[0 0 0.95 1])
% for i=1:3
% % pipe=i+(j-1)*plotperfig;
% switch i
%     case 1; 
%         pipe=1;
%     case 2
%         pipe=5;
%     case 3
%         pipe=10;
% end      
% if pipe>pipenum; break; end
% subplot(2,3,i)
% plot(time,Qepa(pipe,:),'k','linewidth',1.5)
% set(gca,'fontsize',fontsize)
% hold all
% jbfill(time,Qlower(pipe,:),Qupper(pipe,:),'b','b');
% title(['Water flow in pipe ',num2str(pipe)])
% xlabel('Time (Hours)')
% ylabel('Flow (m^3/ h)')
% axis tight
% % legend('EPANET flow', 'IHISE flow bounds')
% grid on
% % Y=get(gca,'ylim');
% % X=[leakTime leakTime];
% % h=line(X,Y,'Color','r','LineWidth',1);
% end
% 
% elevations = d.getNodeElevations;
% for i=4:6
% switch i
%     case 4; 
%         node=1;
%     case 5
%         node=5;
%     case 6
%         node=9;
% end  
% subplot(2,3,i)
% plot(time,Hepa(node,:)-elevations(node),'k','linewidth',1.5)
% set(gca,'fontsize',fontsize)
% hold all
% jbfill(time,hlower(node,:)-elevations(node),hupper(node,:)-elevations(node),'r','r');
% title(['Head at node ',num2str(node)])
% xlabel('Time (Hours)')
% ylabel('Pressure Head (m)')
% axis tight
% % legend('EPANET head', 'IHISE head bounds')
% grid on
% end


%% Aquarisk images
% h(7)=figure;hold all  
% set(gca,'fontsize',14)
% plot(numtime,Qepa(10,[1,1:end-1]),'r','linewidth',1)
% title('Pipe P1')
% grid on
% xlabel('Date & Time')
% ylabel('Flow (m^3/ h)')
% jbfill(numtime',Qlower(10,:),Qupper(10,:),'b','b');
% % legend('Outlet bounds using demand uncertainty',...
% %        'Outlet bounds using reservoir uncertainty')
% set(gca,'XTick',numtime(1):0.25:numtime(end));
% datetick('x',dateFormat,'keepticks','keeplimits')
% set(gca,'XTickLabelRotation',25)
% xlim([numtime(1) numtime(end-abs(n))])
% % axis tight
% 
% %% Flow and pressure estimates
% h(1)=figure;
% subplot(1,2,1)
% plot(numtime',Qepa(1,:))
% title('Water Flow in pipe 1')
% xlabel('Date & Time')
% ylabel('Flow (m^3/ h)')
% set(gca,'XTick',numtime(1):1:numtime(end));
% datetick('x',dateFormat,'keepticks','keeplimits')
% set(gca,'XTickLabelRotation',45)
% axis tight
% 
% subplot(1,2,2)
% elev=d.getNodeElevations; elev=elev(1);
% plot(numtime',Hepa(1,:)-elev(1))
% title('Pressure at node 1')
% xlabel('Date & Time')
% ylabel('Pressure Head (m)')
% set(gca,'XTick',numtime(1):1:numtime(end));
% datetick('x',dateFormat,'keepticks','keeplimits')
% set(gca,'XTickLabelRotation',45)
% axis tight
% 
% %% Reservoir level
% h(2)=figure;hold all
% set(gca,'fontsize',fontsize)
% title('Reservoir level')
% plot(numtime,Hepa(end,:)-55,'.')
% plot(numtime,EstResLev)
% plot(numtime,EstResLevWithLeak)
% xlabel('Date & Time')
% ylabel('Water Level (m)')
% legend('Measured Reservoir Level',...
%        'Estimated Resservoir Level using inflow and DMA outflow',...
%        'Estimated Resservoir Level using inflow and DMA outflow with Leakage')
% set(gca,'XTick',numtime(1):0.5:numtime(end));
% datetick('x',dateFormat,'keepticks','keeplimits')
% set(gca,'XTickLabelRotation',45)
% axis tight
% 
% %% Reservoir Output
% h(3)=figure;hold all
% set(gca,'fontsize',fontsize)
% title('Reservoir Output')
% plot(numtime,ResOut)
% plot(numtime,Qepa(end-1,:))
% xlabel('Date & Time')
% ylabel('Flow (m^3/ h)')
% legend('Estimated Reservoir Outlet using input and level',...
%        'Estimated Reservoir Outlet using DMA outlet and EPANET')
% set(gca,'XTick',numtime(1):0.5:numtime(end));
% datetick('x',dateFormat,'keepticks','keeplimits')
% set(gca,'XTickLabelRotation',45)
% axis tight
% 
% %% Flow and pressure bounds
% fontsize=12;
% pipe=13;
% h(4)=figure;
% subplot(1,2,1)
% plot(numtime,Qepa(pipe,:),'k','linewidth',1)
% set(gca,'fontsize',fontsize)
% hold all
% jbfill(numtime',Qlower(pipe,:),Qupper(pipe,:),'b','b');
% title('Water flow in pipe 13')
% xlabel('Date & Time')
% ylabel('Flow (m^3/ h)')
% set(gca,'XTick',numtime(1):1/12:numtime(end));
% datetick('x',dateFormat,'keepticks','keeplimits')
% set(gca,'XTickLabelRotation',45)
% xlim([numtime(457) numtime(end)])
% % axis tight
% grid on
% %11, 8
% node=8;
% subplot(1,2,2)
% elev=d.getNodeElevations; elev=elev(node);
% plot(numtime,Hepa(node,:)-elev+0.86,'k','linewidth',1)
% set(gca,'fontsize',fontsize)
% hold all
% jbfill(numtime',hlower(node,:)-elev,hupper(node,:)-elev,'r','r');
% title('Pressure head at node 8')
% xlabel('Date & Time')
% ylabel('Pressure Head (m)')
% set(gca,'XTick',numtime(1):1/12:numtime(end));
% datetick('x',dateFormat,'keepticks','keeplimits')
% set(gca,'XTickLabelRotation',45)
% xlim([numtime(457) numtime(end)])
% % axis tight
% grid on
% 
% %% Reservoir Output Bounds
% h(5)=figure;hold all  
% set(gca,'fontsize',fontsize)
% plot(numtime,Qepa(end-1,:))
% title('Reservoir Outlet Bounds')
% grid on
% xlabel('Date & Time')
% ylabel('Flow (m^3/ h)')
% jbfill(numtime',Qlower(end-1,:),Qupper(end-1,:),'b','b');
% jbfill(numtime',ResOutBnds(:,1)',ResOutBnds(:,2)','r','r');
% legend('Outlet bounds using demand uncertainty',...
%        'Outlet bounds using reservoir uncertainty')
% set(gca,'XTick',numtime(1):0.5:numtime(end));
% datetick('x',dateFormat,'keepticks','keeplimits')
% set(gca,'XTickLabelRotation',45)
% xlim([numtime(1) numtime(end-abs(n))])
% % axis tight
% 
% %% Reservoir Output Bounds with Leakage Estimate
% h(6)=figure;hold all
% set(gca,'fontsize',fontsize)
% leak=ones(length(Qlower(end-1,:)),1)*ConstLeakEst;
% plot(numtime,leak)
% title('Reservoir Outlet Bounds with Leakage Estimate')
% grid on
% xlabel('Date & Time')
% ylabel('Flow (m^3/ h)')
% yy1=Qlower(end-1,:)+ConstLeakEst;
% yy2=Qupper(end-1,:)+ConstLeakEst;
% jbfill(numtime',yy1,yy2);
% jbfill(numtime',ResOutBnds(:,1)',ResOutBnds(:,2)','r');
% legend('Leakage Estimate',...
%        'Outlet bounds using demand uncertainty',...
%        'Outlet bounds using reservoir uncertainty') 
% set(gca,'XTick',numtime(1):0.5:numtime(end));
% datetick('x',dateFormat,'keepticks','keeplimits')
% set(gca,'YTick', sort([ConstLeakEst, get(gca, 'YTick')]))
% set(gca,'XTickLabelRotation',45)
% xlim([numtime(1) numtime(end-abs(n))])
% % axis tight


end