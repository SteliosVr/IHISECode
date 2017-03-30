fclose all;clear class;
close all;clear all;clc;
addpath(genpath(pwd))

%% Load Network
% inpname='networks_Test\Net1_CMH_1.inp';
% inpname='networks_Test\Net1_CMH_2.inp';
inpname='networks_Test\Net1_CMH_3.inp';
% inpname='networks_Test\Net1_CMH_4.inp';
% inpname='networks_Test\Net1_CMH_5.inp';

d=epanet(inpname);

Rep_step=d.getTimeReportingStep
Pat_step=d.getTimePatternStep
Hydraulic_step=d.getTimeHydraulicStep
Sim_time=d.getTimeSimulationDuration

base_demands=d.getNodeBaseDemands{1}
base_demands_index=d.getNodeDemandPatternIndex{1}
pattern=d.Pattern

EPAall=d.getComputedHydraulicTimeSeries;
Hepa=EPAall.Head;
Qepa=EPAall.Flow;
nodeTimeSeries=EPAall.Demand;
resIndex=d.getNodeReservoirIndex;
tankIndex=d.getNodeTankIndex;
nodeTimeSeries(:,[resIndex, tankIndex])=...
    Hepa(:,[resIndex, tankIndex]);
nodeTimeSeries=nodeTimeSeries';
Hepa=Hepa';
Qepa=Qepa';

%% Flow and pressure bounds
fontsize=12;
figure
hold all
for i=1:d.LinkCount
pipe=i;
% subplot(d.LinkCount,i)
plot(Qepa(pipe,:),'k','linewidth',1)
set(gca,'fontsize',fontsize)
title('Water flow in pipes')
xlabel('Date & Time')
ylabel('Flow (m^3/ h)')
str=['pipe ',num2str(i)];
legend(str)
grid on
end
%%
figure
hold all
for i=1:d.NodeJunctionCount
node=i;
if i==d.getNodeTankIndex
    figure
    maxtankhead=d.getNodeTankMaximumWaterLevel+d.getNodeElevations(i);
    mintankhead=d.getNodeTankMinimumWaterVolume+d.getNodeElevations(i);
    plot(ones(1,length(Hepa(node,:)))*maxtankhead);
    plot(ones(1,length(Hepa(node,:)))*mintankhead);
end
plot(Hepa(node,:),'k','linewidth',1)
set(gca,'fontsize',fontsize)
title('Head at nodes')
xlabel('Date & Time')
ylabel('Pressure Head (m)')
str=['node ',num2str(i)];
legend(str)
grid on
end
%%
d.unload