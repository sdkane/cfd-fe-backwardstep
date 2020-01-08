%Global Volume and Mass Matrix
function [CvG,MG]=VolumeMatrix(rho,p_ph,p_Jcs,ConM,NELXY,BSTEL)
    nde=4; dim=2;
    [~,w,ngp]=GaPo;
    
    Cve=zeros(nde,nde);                                                     %Empty Matrix for Volume Matrix
    for gn=1:1:ngp
        for K=1:1:nde
            for J=1:1:nde
                Cve(K,J)=Cve(K,J)+p_ph(K,gn)*p_ph(J,gn)*p_Jcs(gn)*w(gn);
            end
        end
    end
    
    M=Cve*rho;
    ML=zeros(nde,nde);
    for i=1:1:nde
        for j=1:1:nde
            ML(i,i)=ML(i,i)+M(i,j);                                         %Lumped Mass Matrix
        end
    end
          
    %Finding the Global Matrix for Mass and Volume
    NmLps=NELXY(1)*NELXY(2);
    NdRm=BSTEL(1)*BSTEL(2);
    ftv=(NELXY(1)+1)*(NELXY(2)+1)-NdRm;
    MG=zeros(ftv,ftv); CvG=zeros(ftv,ftv); %Figure Out Size to Initialize to Later
    for LPS=1:1:(NmLps-NdRm)
        for i=1:1:nde
            ii=ConM(LPS,i);
            for j=1:1:nde
                jj=ConM(LPS,j);
                CvG(ii,jj)=CvG(ii,jj)+Cve(i,j);
                MG(ii,jj)=MG(ii,jj)+ML(i,j);
            end
        end
    end
        
end

%CALLED BY: GlobalSolver
%CALLS: -