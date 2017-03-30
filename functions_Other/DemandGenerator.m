function [ demands ] = DemandGenerator( base_demands,times )
%DEMANDGENERATOR 

simSteps=floor(times.simTime/times.hydStep);
base_demands=cell2mat(base_demands);
% base_demands = [ 0 35 35 20 35 45 35 20 20 30 40 20 35]';
demands=[];
for i=1:simSteps
    demands=[demands; base_demands(1,:)+base_demands(1,:).*0.5*sin(2*pi/288*i)];
end
% save demands demands
% save demands.txt demands -ascii
end

