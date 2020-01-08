%Combines Element Matrices into a Global Matrix
function [fcG,fmG,mfG] = GlobalMatrix(ConM,fc,fm,mf,NELXY,BSTEL)
    nde=4; dim=2;

    NmLps=NELXY(1,1)*NELXY(1,2);
    NdRm=BSTEL(1,1)*BSTEL(1,2);
    ftv=(NELXY(1,1)+1)*(NELXY(1,2)+1)-NdRm;

    fcG=zeros(ftv,dim); fmG=zeros(ftv,dim); mfG=zeros(ftv,dim-1);

    for LPS=1:1:(NmLps-NdRm)
        for i=1:1:nde
            ii=ConM(LPS,i);
            
            fcG(ii,:)=fcG(ii,:)+fc(i,:,LPS);
            fmG(ii,:)=fmG(ii,:)+fm(i,:,LPS);
            mfG(ii,:)=mfG(ii,:)+mf(i,:,LPS);
            
            for j=1:1:nde
                jj=ConM(LPS,j);
%                 fcG(ii,jj)=fcG(ii,jj)+fc(i,j);
%                 fmG(ii,jj)=fmG(ii,jj)+fm(i,j);
%                 mfG(ii,jj)=mfG(ii,jj)+mf(i,j);
            end
        end
    end
    
    
    
end

%CALLED BY: GlobalSolver
%CALLS: