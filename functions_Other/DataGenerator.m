function [ nodeTimeSeries, Qepa, Hepa ] = DataGenerator( d )
%DEMANDGENERATOR 

%% Epanet Simulation
% allParameters=d.getBinComputedAllParameters;
% Qepa = allParameters.BinlinkFlow;
% % nodePressures = allParameters.BinnodePressure;
% Hepa = allParameters.BinnodeHead;
% clc
EPAall=d.getComputedHydraulicTimeSeries;
Hepa=EPAall.Head;
Qepa=EPAall.Flow;
nodeTimeSeries=EPAall.Demand;
resIndex=d.NodeReservoirIndex;
tankIndex=d.NodeTankIndex;
nodeTimeSeries(:,[resIndex, tankIndex])=...
    Hepa(:,[resIndex, tankIndex]);
nodeTimeSeries=nodeTimeSeries';
Hepa=Hepa';
Qepa=Qepa';

% Ktemp = (EPAall.HeadLoss./(abs(EPAall.Flow).^2));
% Kepa = Ktemp(5,:);
% Kepa = Kepa';
end

