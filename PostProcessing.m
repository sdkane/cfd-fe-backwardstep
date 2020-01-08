%Post Processing
%Run After Global Solver
%Imports Velocity from Excel File
clear; clc; clf;

%Read in Velocity
v=xlsread('RunDataRe150_60sec','Velocities Re150');
% v=xlsread('TestDataFV','Velocities Re50');
% v=xlsread('RunDataRe250_300','Velocities Re300');
% P=xlsread('TestDataFV','Pressures Re50');

% vm=xlsread('Solutions','Vel Re150');
% P=xlsread('Solutions','Press Re150');

% 
% ReId=150;
% 
% ttlvar1=sprintf('Velocity Contour Re=%0.0f',ReId);
% ttlvar2=sprintf('Pressure Contour Re=%0.0f',ReId);

%Set Up Conditions From Global Solver
NELXY=[30,12];%[4,4];%
BSTEL=[5,6];%[2,1];%
MshXY=[0.12,0.24/14];

%Determine True XY Coordinates of Nodes
XYCoords=NodalXYCoords(NELXY,BSTEL,MshXY);
ConM=ConnectMatrix(NELXY,BSTEL);
% AdjNds=AdjacentNodes(NELXY,BSTEL);
InNd=InletNodes(NELXY,BSTEL);

% % Velocity Arrow Plot
% PlotMeshGrid(NELXY,BSTEL,MshXY);
% VelocityContour(v,XYCoords,'xa')

% % Velocity Pressure Plots
% subplot(2,1,1); 
%                PlotMeshGrid(NELXY,BSTEL,MshXY);
%                VelocityContourMid(v,XYCoords,ConM,MshXY,NELXY)
%                title(ttlvar1)
%                 
% subplot(2,1,2); 
%                PlotMeshGrid(NELXY,BSTEL,MshXY);
%                PressureContourMid(P,XYCoords,ConM,MshXY,NELXY)
%                title(ttlvar2)

PlotMeshGrid(NELXY,BSTEL,MshXY);
StreamLine_v3(InNd,ConM,NELXY,MshXY,XYCoords,v)

% % BackUpCodeStreamlines(NELXY,MshXY,AdjNds,XYCoords,InNd,v)
% % StreamLinesMid(XYCoords,InNd,v,ConM,MshXY,NELXY)








% % Velocity Comparison Plots
% ttlvar1=sprintf('Kane Velocity Contour Re=%0.0f',ReId);
% ttlvar2=sprintf('Murdock Velocity Contour Re=%0.0f',ReId);
% subplot(2,1,1); 
%                PlotMeshGrid(NELXY,BSTEL,MshXY);
%                VelocityContourMid(v,XYCoords,ConM,MshXY,NELXY)
%                title(ttlvar1)
%                 
% subplot(2,1,2); 
%                PlotMeshGrid(NELXY,BSTEL,MshXY);
%                VelocityContourMid(vm,XYCoords,ConM,MshXY,NELXY)
%                title(ttlvar2)

% % Velocity Arrow Comparison Plots
% subplot(2,1,1); 
% PlotMeshGrid(NELXY,BSTEL,MshXY);
% VelocityContour(v,XYCoords,'xa')
%                 
% subplot(2,1,2); 
% PlotMeshGrid(NELXY,BSTEL,MshXY);
% VelocityContour(vm,XYCoords,'xa')
