fclose all;clear class;
close all;clear all;clc;

%%
% inpname='Anytown.inp';
% inpname='RuralNetwork.inp'
inpname='Net3.inp'


%%
d=epanet(inpname);
d.setBinFlowUnitsCMH;
inpname(end-3:end) = [];
d.saveInputFile([inpname,'_CMH.inp']);

d.unload