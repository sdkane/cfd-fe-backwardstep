%Computes Global Constants
%Elements are Uniform, Element Variables, Jacobian and Inverse Become Constant
function [p_ph,p_Jcs,p_Jdph,p_phFV,p_JdphFV,p_phFVie,p_JdphFVie] = GlobalConstants(MshXY,NELXY,SlvTyp)
    nde=4; dim=2;                                                           %Number of Local Nodes, Dimensions
    [gp,~,ngp]=GaPo;
    xe=ElementSize(MshXY,NELXY);
    
    p_Jcs=zeros(ngp); p_ph=zeros(nde,ngp);                                  %Empty Matrices for pre-calculations
    p_dph=zeros(nde,dim,ngp); p_Jis=zeros(dim,dim,ngp);
    p_Jdph=zeros(nde,dim,ngp);
    
    for gn=1:1:ngp
        p_Jcs(gn)=det(Cmpt('Jac',gp(gn,:),xe));                             %[Element Variable] Determinant of Jacobian  (det(dxdxi))
        p_ph(:,gn)=Cmpt('Phi',gp(gn,:));                                    %[Global Constant]  Shape Function  (Ns)
        p_dph(:,:,gn)=Cmpt('dPhi',gp(gn,:));                                %[Global Constant]  Derivative of Shape Function (dNDxi)
        p_Jis(:,:,gn)=inv(Cmpt('Jac',gp(gn,:),xe));                         %[Element Variable] Inverse Jacobian Components (dxidx)
    end

    for gn=1:1:ngp
        for I=1:1:nde
            for i=1:1:dim
                for j=1:1:dim
                    p_Jdph(I,i,gn)=p_Jdph(I,i,gn)+p_Jis(i,j,gn)*p_dph(I,j,gn);    %[Element Variable] Derivative of Shape Function in Global Coordinates (dNdx)
                end
            end
        end
    end
    

    if SlvTyp==0 %Finite Volume
        mdpt=[0,-0.5; 0.5,0; 0,0.5; -0.5,0];
        egpt=[-1,-0.5; -1,0.5; 1,-0.5; 1,0.5];
        p_phFV=zeros(4,4);
        for ii=1:1:4
            p_phFV(ii,:)=Cmpt('Phi',mdpt(ii,:));
            p_phFVie(ii,:)=Cmpt('Phi',egpt(ii,:));
        end

        for gn=1:1:ngp
%             p_JcsFV(gn)=det(Cmpt('Jac',mdpt(gn,:),xe));                             %[Element Variable] Determinant of Jacobian  (det(dxdxi))
%             p_phFV(:,gn)=Cmpt('Phi',mdpt(gn,:));                                    %[Global Constant]  Shape Function  (Ns)
            p_dphFV(:,:,gn)=Cmpt('dPhi',mdpt(gn,:));                                %[Global Constant]  Derivative of Shape Function (dNDxi)
            p_JisFV(:,:,gn)=inv(Cmpt('Jac',mdpt(gn,:),xe));                         %[Element Variable] Inverse Jacobian Components (dxidx)
            p_dphFVie(:,:,gn)=Cmpt('dPhi',egpt(gn,:));
            p_JisFVie(:,:,gn)=inv(Cmpt('Jac',egpt(gn,:),xe));
        end
        
        p_JdphFV=zeros(nde,dim,ngp);p_JdphFVie=zeros(nde,dim,ngp);
        for gn=1:1:nde
            for I=1:1:nde
                for i=1:1:dim
                    for j=1:1:dim
                        p_JdphFV(I,i,gn)=p_JdphFV(I,i,gn)+p_JisFV(i,j,gn)*p_dphFV(I,j,gn);    %[Element Variable] Derivative of Shape Function in Global Coordinates (dNdx)
                        p_JdphFVie(I,i,gn)=p_JdphFVie(I,i,gn)+p_JisFVie(i,j,gn)*p_dphFVie(I,j,gn);
                    end
                end
            end
        end
        
    else
        p_phFV=0;
        p_JdphFV=0;
        p_phFVie=0;
        p_JdphFVie=0;
    end

end

%CALLED BY: GlobalSolver
%CALLS: ElementSize, Cmpt