%ElementMatrices Solver
%The last two inputs are the global velocity and pressure matrices at a
%given time

function [fc,fm,mf] = ElementMatrices(p_ph,p_Jcs,p_Jdph,NELXY,BSTEL,ConM,v,P,rho,mu,cr,SlvTyp,p_phFV,p_JdphFV,LV)
    
    TlEL=NELXY(1)*NELXY(2)-BSTEL(1)*BSTEL(2);   %Total Number of Elements
    %%%%%%%%%%%%%%%%%%
    %Preallocate Matrices
    fc=zeros(4,2,TlEL);
    fm=zeros(4,2,TlEL);
%     fb=zeros(1,1,Ttlp);       %Assumption, No Body Forces
    mf=zeros(4,1,TlEL);
    %%%%%%%%%%%%%%%%%%
    
    %For Each Element of the Mesh Section, Call the Element Terms
    for LPS=1:1:TlEL
        [ue,Pe]=ElementPV(ConM,v,P,LPS);                            %Picks out Element Velocities and Pressures from Global matrices
        if SlvTyp==1
            [fc(:,:,LPS),fm(:,:,LPS),mf(:,:,LPS)]=ElementTermsFE(p_ph,p_Jcs,p_Jdph,ue,Pe,rho,mu,cr);
        else
            [fc(:,:,LPS),fm(:,:,LPS),mf(:,:,LPS)]=ElementTermsFV(ue,Pe,p_phFV,p_JdphFV,rho,mu,cr,LV);
        end
    end
        
end

%Calls ElementTerms for each element in the described space
%Sends to Element Terms [xe,ue,Pe,be] for each element
%[xe,ue,Pe,be] are stored in ElementConditions
%Element is called out by ELN (Element Number)