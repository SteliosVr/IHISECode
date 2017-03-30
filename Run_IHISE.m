fclose all;clear class;
close all;clear;clc;

% Add paths
load_paths()
% profile on

% Load Network
% inpname='networks_Ready\Ready_Net1_CMH_3.inp';

%%%%%%% Only Reservoirs, H-W
% inpname='networks_Ready\Ready_Net1_CMH_1.inp';
% inpname='networks_Ready\Ready_Net1_CMH_5.inp';
% inpname='networks_Ready\Ready_Anytown_CMH_onlyRes.inp';
% inpname='networks_Ready\Ready_Net1_CMH_1-rapid-flow-change.inp';
% inpname='networks_Ready\Ready_Net2_CMH_onlyRes.inp';
% inpname='networks_Ready\Ready_Net3_CMH_onlyRes.inp';
% inpname='networks_Ready\RuralNetwork_CMH_H-W.inp';

%%%%%%% Only Reservoirs, H-W, with Pumps
% inpname='networks_Ready\Ready_Net1_CMH_2.inp';
% inpname='networks_Ready\Ready_Net1_CMH_4_onlyRes.inp';
% inpname='networks_Ready\Ready_Net3_CMH_onlyRes_withPumps.inp';

%%%%%%% Variable head reservoir, H-W, with Pumps
inpname='networks_Ready\Ready_Net1_CMH_3_VariableHeadRes.inp';

d=epanet(inpname);
% d.plot

%% Define simulation times
simTime=d.getTimeSimulationDuration;
hydStep=d.getTimeHydraulicStep;
times=struct('simTime',simTime,'hydStep',hydStep);

%% Generate node time series and simulate with epanet
% nodeTimeseries (n_n x simSteps) contains all the nodes sorted by index
% demand nodes have the node demand for every simulation step
% reservoir nodes have the total head for every simulation step
% tank nodes have the  the total head (elevation + tanklevel) for every simulation step
[ nodeTimeSeries, Qepa, Hepa ] = DataGenerator( d );

%check for Epanet negative pressures
elev=repmat(double(d.getNodeElevations'),[1,size(Hepa,2)]);
if any(any((Hepa-elev)<0))
    error('Epanet returned negative pressures')
end

%% Insert uncertainty
Kunc=0.02; %pipe parameter uncertainty
qunc=0.02; %demand uncertainty

%% Run IHISE
[ Qlower, Qupper, hlower, hupper] = IHISE_TimeSteps(d, nodeTimeSeries, times, Kunc, qunc, Qepa, Hepa );

%% Simulate leakage
d.unload;
inpname='networks_Ready\Ready_Net1_CMH_3_VariableHeadRes_WithLeak.inp';
d=epanet(inpname);
[ nodeTimeSeries, Qepa, Hepa ] = DataGenerator( d );

%% Plot results
% profile viewer

PlotResults(d, times, Qepa, Hepa, Qlower, Qupper, hlower, hupper);

% savefig(h,'PaperFigures.fig','compact')
% close(h)

strstart = max(strfind(inpname,'\'))+1;
filename=['IHISE-',inpname(strstart:end-4)];
save(filename)

d.unload; %unloads libraries and deletes temp files


