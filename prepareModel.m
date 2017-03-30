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

%% Set times
simTime=24*60*60; %in seconds
hydStep=5*60; %in seconds
simSteps=floor(simTime/hydStep);

d.setTimeReportingStep(hydStep);
d.setTimePatternStep(hydStep);
d.setTimeHydraulicStep(hydStep);%hydraulic step in seconds
d.setTimeSimulationDuration(simTime)%simulation time in seconds

%% Insert demands to the network

%create demands = 1, don't create demands =0
Create_Demands=1; 

%create demands timeseries
if Create_Demands;
base_demands=d.getNodeBaseDemands{1};
demands=[];
for i=1:simSteps
    demands=[demands; base_demands(1,:)+...
                      base_demands(1,:)*0.5.*(...
                      rand(size(base_demands(1,:)))*sin(2*pi/288*i)*cos(2*pi/288*i)+...
                      rand(size(base_demands(1,:)))*sin(4*pi/288*i)*cos(4*pi/288*i)...
                      )];
end
%%Set base demands equal to 1
dem=ones(size(base_demands));
d.setNodeBaseDemands({dem});          
%%Set Patterns equal to actual demands from database
demInd = d.getNodeDemandPatternIndex{1}; 
for i=1:d.NodeJunctionCount
    ind=d.addPattern(['P',d.NodeJunctionNameID{i}],demands(:,i));
    demInd(i)=ind;
end
d.setNodeDemandPatternIndex(demInd)
end
%% Save input file
inpname(1:14) = [];
inpname(end-3:end) = [];
% Readyinpname=['ready_networks\Ready_',inpname,'.inp'];
Readyinpname=['Ready_',inpname,'.inp'];
d.saveInputFile(Readyinpname);
d.unload;

%% Run IHISE
% run run_IHISE
