function [ Qbnd, hbnd, y ] = Initial_Bounds(d,intv,n,restankLevels,Kbnd,qbnd,Pcoef)
%INITIAL_BOUNDS 

%% Define
n_org=n;
Kl=Kbnd(:,1);
Ku=Kbnd(:,2);
qu=qbnd(:,2);
Acoef=Pcoef.Acoef;
restankIndex=[d.getNodeTankIndex d.getNodeReservoirIndex];
restankIndex(find(restankIndex==0))=[];

%% Construct Network Matrices
[ A12, A21, hext ] = Network_Matrices( d, restankLevels );

%% Find initial bounds on heads (h)
Qinit = 1*ones(d.LinkCount,1);
hinit = double(d.NodeElevations');
hinit(restankIndex)=[]; %remove nodes with known head
Qhut = Qinit; hhut = hinit;

% lower bound on heads is node elevations
hlow=hinit;
% upper bound on heads is the sum of:
%reservoir heads, tank heads, pump cutoff heads 
% hup=sum(restankLevels)*ones(size(hlow))+ sum(Ccoef);
hup=sum(restankLevels)*ones(size(hlow))+ sum(Acoef);

%% Find initial bounds on (Q)
hbnd=intv.def(hlow,hup);
Kbnd=intv.def(Kl,Ku);
y=intv.mult(-A12,hbnd);
y=intv.sub(y,hext);
y=intv.div(y,Kbnd);
y=intv.int2mat(y);
hbnd=intv.int2mat(hbnd);

for i=1:size(y,1)
    %link is a pump
    if any(i==d.LinkPumpIndex); 
       Q(i,1)=0;
       Q(i,2)=10*sum(qu);
       continue
    end
    
    %link is a pipe
    Q(i,1)=(abs(y(i,1)))^(1/n);
    if y(i,1)<0; Q(i,1)=-Q(i,1);end

    Q(i,2)=(abs(y(i,2)))^(1/n);
    if y(i,2)<0; Q(i,2)=-Q(i,2);end

    lowtemp=min(Q(i,1),Q(i,2)); uptemp=max(Q(i,1),Q(i,2));
    Q(i,1)=lowtemp; Q(i,2)=uptemp;
    n=n_org;
end
Qbnd=Q;
[ ~, ~, ~, RTL ] = Network_Matrices( d, restankLevels );
Qbnd(:,2)=Qbnd(:,2)+abs(Qbnd(:,2)).*abs(RTL');
Qbnd(12,1)=0;%!!!!!!!!!!!!!!!!!! cheat
% Qbnd=1000*ones(size(Q));
% Qbnd(:,1)=Qbnd(:,1)*(-1);

end

