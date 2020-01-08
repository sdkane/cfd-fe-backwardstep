%Backward Facing Step CFD Solver
%Assumes: Uniform Rectangular Elements, Incompressible Flow, No Body Forces
%Assumes: Laminar Flow - No Turbulence Modeling
%Solves: Gauss Quadrature, Trapezoidal Integration Rule
clear; clc;
kk=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for ReN=250:50:300
%User Edit Variables

%Solver Type
SlvTyp=0; %(1) for Finite Element (0) for Finite Volume

%Time Variables
tst=1;%0.00005;                                                                %Step Time
ndtm=500;                                                                    %End Time (secs)


%Velocity Input Scaling
VelInitX=0; VelInitY=0;                                                     %Initial Universal velocity Within Pipe
pptst=0.000001;                                                             %Plus Per Time Step at Inlet - Max Determined by Reynolds Number

%Fluid Properties
ReN=50;                                                                     %Max Reynolds Number
rho=1000;                                                                   %Density, Constant-Incompressible Flow
mu=0.001;                                                                   %Viscosity
MaNu=0.05;                                                                  %Mach Number

%Pipe Properties
l=0.1; h=l/14*2; lt=0.1+0.1/25*5;

MshXY=[lt,h];                                                               %Total Length and Total Height of Pipe (X,Y)

%Mesh Variables
NELXY=[30,12];                                                              %Number of Elements in Mesh (X,Y)
BSTEL=[5,6];                                                                %Number of Elements in Backward Step (X,Y) 

% NELXY=[10,10]; BSTEL=[2,1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initializations
hlst=tst/2;                                                                 %Half Time Step
rtmi=ndtm/tst+1;                                                            %Run Time Index Number

elnm=NELXY(1)*NELXY(2)-BSTEL(1)*BSTEL(2);                                   %Number of Elements

grsz=MshXY(2)/NELXY(2);                                                     %Element Size in Y
chln=(NELXY(2)-BSTEL(2))*grsz;                                              %Computes Characteristic Length of Pipe
umax=ReN*mu/(rho*chln);                                                     %Computes Max Velocity

LV=[MshXY(2)/(2*NELXY(2)),MshXY(1)/(2*NELXY(1))];                         %Computes Element Half Sizes for Finite Volume

AdjNds=AdjacentNodes(NELXY,BSTEL);                                          %Determines Adjacent Nodes
ConM=ConnectMatrix(NELXY,BSTEL);                                            %Generates the Connectivity Matrix
InNd=InletNodes(NELXY,BSTEL);                                               %Sets Inlet Nodes in Terms of Connectivity Matrix
ExNd=ExitNodes(NELXY,BSTEL);
BndNds=BoundaryNodes(NELXY,BSTEL);                                          %Sets Boundary Conditions in Terms of Connectivity Matrix

[p_ph,p_Jcs,p_Jdph,p_phFV,p_JdphFV,p_phFVie,p_JdphFVie]=GlobalConstants(MshXY,NELXY,SlvTyp);    %Computes Element Constants, Ph, dPh, Jacobian, Jacobian Inverse 
                                                                                                                                                        
[CvG,MG]=VolumeMatrix(rho,p_ph,p_Jcs,ConM,NELXY,BSTEL);                     %Computes Global Volume and Mass Matrics, Constant-Incompressible Flow
CvGinv=inv(CvG); MGinv=inv(MG);                                             %Computes Invariant Inverses of Global Volume and Mass Matrices

%Setting Initial Conditions
NdRm=BSTEL(1)*BSTEL(2);
ftv=(NELXY(1)+1)*(NELXY(2)+1)-NdRm;                                         %Matrix Size, Total Number of Nodes
v=zeros(ftv,2,1); dvdt=zeros(ftv,2,1);                                      %Empty Matrices
v(:,1,1)=VelInitX; v(:,2,1)=VelInitY;                                       %Setting to Predefined Initial Conditions

P=zeros(ftv,1); dPdt=zeros(ftv,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Max Velocity:         %f\nSteps to Reach V_max: %0.0f\nTotal Time Steps:     %0.0f\nNumber of Elements:   %0.0f\n\n',umax,ceil(umax/pptst),rtmi,elnm);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
for tme=1:1:rtmi
    %Scaling Velocity Input and Finding Compressibility Factor
    [v,cr]=VelocityScale(InNd,v,umax,pptst,MaNu,chln,grsz,tme);
%     [v(:,:,tme),cr]=VelocityScale(InNd,v(:,:,tme),umax,pptst,MaNu,chln,grsz,tme);
        
    %Find Matrices for Elements at time=tme
    [fc,fm,mf]=ElementMatrices(p_ph,p_Jcs,p_Jdph,NELXY,BSTEL,ConM,v,P,rho,mu,cr,SlvTyp,p_phFV,p_JdphFV,LV);
    
    if SlvTyp==0
        [fc,fm,mf]=InExCnd(InNd,ExNd,ConM,LV,p_phFVie,p_JdphFVie,v,P,fc,fm,mf,rho,mu,cr);
    end

%     [fc,fm,mf]=ElementMatrices(p_ph,p_Jcs,p_Jdph,NELXY,BSTEL,ConM,v(:,:,tme),P(:,:,tme),rho,mu,cr);
    
    %Global Matrices
    [fcG,fmG,mfG]=GlobalMatrix(ConM,fc,fm,mf,NELXY,BSTEL);                  %Combines the Matrices of Mesh Section 1 and Mesh Section 2

    %Solve For Next Time Step
    dvdt_tp=MGinv*(fcG+fmG);                                                %Trapezoidal Integration Rule For Velocity and Pressure
    dPdt_tp=CvGinv*mfG;
        
    v_nw=v+hlst*(dvdt+dvdt_tp);
    P_nw=P+hlst*(dPdt+dPdt_tp);
%     v_diff=v_nw-v;
%     v=v_nw; P=P_nw;
    dvdt=dvdt_tp; dPdt=dPdt_tp;
    
%%%%%%%%%% Save Every Step        
%     %Solve For Next Time Step
%     dvdt(:,:,tme+1)=MGinv*(fcG+fmG);                                        %Trapezoidal Integration Rule For Velocity and Pressure
%     dPdt(:,:,tme+1)=CvGinv*mfG;
%         
%     v(:,:,tme+1)=v(:,:,tme)+hlst*(dvdt(:,:,tme)+dvdt(:,:,tme+1));
%     P(:,:,tme+1)=P(:,:,tme)+hlst*(dPdt(:,:,tme)+dPdt(:,:,tme+1));
%%%%%%%%%%

    %Implementing Boundary Conditions
    [v_nw,P_nw]=BndCnd(BndNds,v_nw,P_nw);
    v_diff=v_nw-v;
    v=v_nw; P=P_nw;
%     [v(:,:,tme+1),P(:,:,tme+1)]=BndCnd(BndNds,v(:,:,tme+1),P(:,:,tme+1));

    %Setting Exit Pressures
    P=PresExit(ExNd,P);
    
    %Pressure Averaging
    P=PresAvg(AdjNds,NELXY,BSTEL,P);
%     P(:,:,tme+1)=PresAvg(P(:,:,tme+1));
    
    
    %Print Estimated Completion Time
    if tme==100
        etm=toc;
        ttestm=etm*ndtm/tst/60/100;
        fprintf('<> Estimated Run Time: %0.5f min(s) <>\n',ttestm);
        fprintf('<> Ctrl+C To Force Stop <>\n\n');
    end
    
end
ttm=toc/60;
fprintf('<> RUN COMPLETE <>\n');
fprintf('<> Total Elapsed Time: %0.5f min(s) <>\n\n',ttm);

% PlotMeshGrid(NELXY,BSTEL,MshXY);

% V_ReN(:,:,kk)=v;
% V_Diff(:,:,kk)=v_diff;
% P_ReN(:,:,kk)=P;
% kk=kk+1;
% end
% 
% filename='TestDataFV6x6B2x1.xlsx';
% xlswrite(filename,V_ReN(:,:,1),'Velocities Re50');
% xlswrite(filename,V_ReN(:,:,2),'Velocities Re300');
% % xlswrite(filename,V_ReN(:,:,3),'Velocities Re150');
% % xlswrite(filename,V_ReN(:,:,4),'Velocities Re200');
% % xlswrite(filename,V_ReN(:,:,5),'Velocities Re250');
% % xlswrite(filename,V_ReN(:,:,6),'Velocities Re300');
% % 
% xlswrite(filename,V_Diff(:,:,1),'VelocitiesDifference Re50');
% xlswrite(filename,V_Diff(:,:,2),'VelocitiesDifference Re300');
% % xlswrite(filename,V_Diff(:,:,3),'VelocitiesDifference Re150');
% % xlswrite(filename,V_Diff(:,:,4),'VelocitiesDifference Re200');
% % xlswrite(filename,V_Diff(:,:,5),'VelocitiesDifference Re250');
% % xlswrite(filename,V_Diff(:,:,6),'VelocitiesDifference Re300');
% % 
% xlswrite(filename,P_ReN(:,:,1),'Pressures Re50');
% xlswrite(filename,P_ReN(:,:,2),'Pressures Re300');
% % xlswrite(filename,P_ReN(:,:,3),'Pressures Re50');
% % xlswrite(filename,P_ReN(:,:,4),'Pressures Re50');
% % xlswrite(filename,P_ReN(:,:,5),'Pressures Re50');
% % xlswrite(filename,P_ReN(:,:,6),'Pressures Re50');

% wavplay(wavread('LTTP_ItemFanfare_Stereo'))
%CALLS: Everything...