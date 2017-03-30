function [Q, H] = EPAsimulation( d )

%load network
% d=epanet('networks\Net1_Rossman2000.inp');

%%Run simulation and return results
allParameters=d.getBinComputedAllParameters;
Q = allParameters.BinlinkFlow;
% nodePressures = allParameters.BinnodePressure;
H = allParameters.BinnodeHead;
clc
% allParameters=d.getComputedHydraulicTimeSeries;
% Q = allParameters.Flow;
% % nodePressures = allParameters.BinnodePressure;
% H = allParameters.Head;

end