function [ Pcoef ] = Pump_Coefficients( d )
%PUMP_COEFFICIENTS
Acoef=[];
Bcoef=[];
Ccoef=[];

%Calculate coefficients with lsqcurvefit
pumpIndex=d.HeadCurveIndex;
if ~isempty(pumpIndex)
    for i=1:d.LinkPumpCount
        points=d.getCurveValue(pumpIndex(i));
        xdata=points(:,1);
        ydata=points(:,2);
        x0=[50 0.1 2];
        CurPar=lsqcurvefit(@(x,xdata) x(1)-x(2)*xdata.^x(3),x0,xdata,ydata);
        Acoef(i)=CurPar(1);
        Bcoef(i)=CurPar(2);
        Ccoef(i)=CurPar(3);
        
        %Plot curves
%         figure
%         xt=floor(min(xdata)):ceil(max(xdata));
%         yt=ones(1,length(xt))*Acoef(i)-Bcoef(i)*xt.^Ccoef(i);
%         plot(xdata,ydata,'r*')
%         hold all
%         plot(xt,yt)
    end
end

%Calculate pump curve function coefficients: H = AQ^2+BQ+C
%based on given curve points
% pumpIndex=d.HeadCurveIndex;
% if ~isempty(pumpIndex)
%     for i=1:d.LinkPumpCount
%         points=d.getCurveValue(pumpIndex(i));
%         x=points(:,1);
%         y=points(:,2);
%         H=[x.^2 x ones(length(x),1)];
% %         H=[x.^2 ones(length(x),1)];
%         z=y;
%         CurPar=pinv(H)*z;
%         Acoef(i)=CurPar(1);
%         Bcoef(i)=CurPar(2);
%         Ccoef(i)=CurPar(3);
% %         Ccoef(i)=CurPar(2);
%         %check pump curve:
%     %     figure
%     %     x=0:3000;
%     % %     y=Acoef(i).*x.^2+Bcoef(i).*x+Ccoef(i);
%     %     y=Acoef(i).*x.^2+Ccoef(i);
%     %     plot(x,y)
%     end
% end

% Create struct
Pcoef = struct('Acoef',Acoef,'Bcoef',Bcoef,'Ccoef',Ccoef);
end

