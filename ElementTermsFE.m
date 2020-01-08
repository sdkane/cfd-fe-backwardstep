%Element: Mass Matrix, Convective, Material and, Body Force Vectors
%Mass Flux Vector, Convective, Pressure, Viscosity and, Mass Flux Matrices
%Incompressible Flow - Gaussian Integration
%4-Noded Rectangular Element
function [fc,fm,mf] = ElementTermsFE(pre_ph,pre_Jcs,pre_Jdph,ue,Pe,rho,mu,cr)
    dim=2; nde=4;                                                               %[Global Constant]  Number of Dimensions / Number of Nodes
    [~,w,ngp]=GaPo;

    p_Vel=zeros(dim,ngp);                                                       %Empty Matrices for pre-calculations
    p_dVel=zeros(dim,dim,ngp); p_dPres=zeros(dim,ngp);                      

    for gn=1:1:ngp
        for i=1:1:dim
            for I=1:1:nde
                p_dPres(i,gn)=p_dPres(i,gn)+pre_Jdph(I,i,gn)*Pe(I);             %[Element Variable] Derivative of Pressure (dPdx)
                p_Vel(i,gn)=p_Vel(i,gn)+pre_ph(I,gn)*ue(I,i);                   %[Element Variable] Velocity in Gloabal Coordinates (v)   
                for j=1:1:dim          
                    p_dVel(i,j,gn)=p_dVel(i,j,gn)+pre_Jdph(I,j,gn)*ue(I,i);     %[Element Variable] Derivative of Velocity (dvdx)
                end
            end
        end
    end

    pre_dVel_ii=zeros(ngp); pre_dVel_v=zeros(dim,ngp);                          %Empty Matrices for pre-calculations
    for gn=1:1:ngp
        pre_dVel_ii(gn)=p_dVel(1,1,gn)+p_dVel(2,2,gn);                          %[Element Variable] Summation of Diagonal Terms (dvdx_ii)
        for i=1:1:dim
            for j=1:1:dim
                pre_dVel_v(i,gn)=pre_dVel_v(i,gn)+p_dVel(i,j,gn)*p_Vel(j,gn);   %[Element Variable] (dvdx_v)
            end
        end
    end

    %Final Calculations
    fc=zeros(nde,dim); fm=zeros(nde,dim); fb=zeros(nde,dim); mf=zeros(nde,1);   %Empty Matrices for Vectors
    for gn=1:1:ngp
        for K=1:1:nde
            mf(K)=mf(K)+(-rho/cr)*pre_dVel_ii(gn)*pre_ph(K,gn)*pre_Jcs(gn)*w(gn);
            for i=1:1:dim
                fc(K,i)=fc(K,i)+(-rho)*(pre_dVel_v(i,gn)+p_Vel(i,gn)*pre_dVel_ii(gn))*pre_ph(K,gn)*pre_Jcs(gn)*w(gn);
                fm(K,i)=fm(K,i)+(-p_dPres(i,gn)*pre_ph(K,gn)-mu*(p_dVel(i,1,gn)*pre_Jdph(K,1,gn)+p_dVel(i,2,gn)*pre_Jdph(K,2,gn)))*pre_Jcs(gn)*w(gn);
    %             fb(K,i)=fb(K,i)+rho*be(i)*pre_ph(K,gn)*pre_Jcs(gn)*w(gn);
            end
        end
    end
end