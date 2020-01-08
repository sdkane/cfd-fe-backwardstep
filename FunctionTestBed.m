%FunctionTestBed
clear; clc; clf;
 
% v=xlsread('RunDataRe50_100','Velocities Re50');
% l=0.1; h=l/14*2; lt=0.1+0.1/25*5;
% NELXY=[30,12];
% BSTEL=[5,6];
% MshXY=[lt,h]

% v=xlsread('TestData');
NELXY=[5,5];
BSTEL=[3    ,3];
% MshXY=[0.1,0.1];
InNd=InletNodes(NELXY,BSTEL)
ExNd=ExitNodes(NELXY,BSTEL)


% AdjNds=AdjacentNodes(NELXY,BSTEL);
% % ConM=ConnectMatrix(NELXY,BSTEL);
% XYCoords=NodalXYCoords(NELXY,BSTEL,MshXY)
% % hold on
% PlotMeshGrid(NELXY,BSTEL,MshXY);
% % hold on
% 
%     NdsX=NELXY(1)+1;    %Nodes in X
%     NdsY=NELXY(2)+1;    %Nodes in Y
% 
%     ElX=MshXY(1)/NELXY(1);                  %Element Width
%     ElY=MshXY(2)/NELXY(2);                  %Element Height
% 
%     BsX=BSTEL(1)*ElX;                       %Total Backstep Width
%     BsY=BSTEL(2)*ElY;                       %Total Backstep Height
% 
%     TWidth=MshXY(1)
%     THeight=MshXY(2);
% % axis([-ElX,TWidth+ElX,-ElY,THeight+ElY]);
% PlotContour(v,XYCoords,'xa');
% % hold off





% BndCnd=BoundaryNodes(NELXY,BSTEL)

% InNd=InletNodes(NELXY,BSTEL)
% mu=0.001;
% rho=1000;
% tme=1;
% MaNu=0.05;
% ReN=50;
% pptst=0.1;
% MshXY=[1,1];
% grsz=MshXY(2)/NELXY(2);
% chln=(NELXY(2)-BSTEL(2))*grsz;                                              %Computes Characteristic Length of Pipe
% convrat=4/chln;
% umax=ReN*mu/(rho*chln);
% 
% NdRm=BSTEL(1)*BSTEL(2);
% ftv=(NELXY(1)+1)*(NELXY(2)+1)-NdRm;                                         %Matrix Size
% v=zeros(ftv,2,1);
% 
% [v,cr] = VelocityScale(InNd,v,umax,pptst,MaNu,convrat,grsz,tme)


% 
% MshXY=[1,1];
% rho=1000;
% [p_ph,p_Jcs,p_Jis]=GlobalConstants(MshXY,NELXY);
% [CvG,MG]=VolumeMatrix(rho,p_ph,p_Jcs,ConM,NELXY,BSTEL)