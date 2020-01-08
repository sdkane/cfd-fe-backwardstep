%Finite Volume Element Convective and Material Force Solver
function [fc,fm,mf] = ElementTermsFV(ue,Pe,p_phFV,p_JdphFV,rho,mu,cr,LV)
    dim=2; nde=4;  %Dimensions and Nodes
    delk=eye(dim); %Delta Kronecker

    L59=LV(1); L69=LV(2); L79=LV(1); L89=LV(2); %Lengths from "nodes" [5->9, 6->9, 7->9, 8->9] 
    n59=[1,0];    n69=[0,1];    n79=[-1,0];    n89=[0,-1];

    v59x=ue(1,1)*p_phFV(1,1)+ue(2,1)*p_phFV(1,2)+ue(3,1)*p_phFV(1,3)+ue(4,1)*p_phFV(1,4);   %ph(1,#) is ph(pt59,ph#)
    v59y=ue(1,2)*p_phFV(1,1)+ue(2,2)*p_phFV(1,2)+ue(3,2)*p_phFV(1,3)+ue(4,2)*p_phFV(1,4);
    v59=[v59x,v59y];
    P59=Pe(1)*p_phFV(1,1)+Pe(2)*p_phFV(1,2)+Pe(3)*p_phFV(1,3)+Pe(4,1)*p_phFV(1,4);   
        
    v69x=ue(1,1)*p_phFV(2,1)+ue(2,1)*p_phFV(2,2)+ue(3,1)*p_phFV(2,3)+ue(4,1)*p_phFV(2,4);   %ph(2,#) is ph(pt69,ph#)
    v69y=ue(1,2)*p_phFV(2,1)+ue(2,2)*p_phFV(2,2)+ue(3,2)*p_phFV(2,3)+ue(4,2)*p_phFV(2,4);
    v69=[v69x,v69y];
    P69=Pe(1)*p_phFV(2,1)+Pe(2)*p_phFV(2,2)+Pe(3)*p_phFV(2,3)+Pe(4,1)*p_phFV(2,4);   
    
    v79x=ue(1,1)*p_phFV(3,1)+ue(2,1)*p_phFV(3,2)+ue(3,1)*p_phFV(3,3)+ue(4,1)*p_phFV(3,4);   %ph(3,#) is ph(pt79,ph#)
    v79y=ue(1,2)*p_phFV(3,1)+ue(2,2)*p_phFV(3,2)+ue(3,2)*p_phFV(3,3)+ue(4,2)*p_phFV(3,4);
    v79=[v79x,v79y];
    P79=Pe(1)*p_phFV(3,1)+Pe(2)*p_phFV(3,2)+Pe(3)*p_phFV(3,3)+Pe(4,1)*p_phFV(3,4);   
    
    v89x=ue(1,1)*p_phFV(4,1)+ue(2,1)*p_phFV(4,2)+ue(3,1)*p_phFV(4,3)+ue(4,1)*p_phFV(4,4);   %ph(4,#) is ph(pt89,ph#)
    v89y=ue(1,2)*p_phFV(4,1)+ue(2,2)*p_phFV(4,2)+ue(3,2)*p_phFV(4,3)+ue(4,2)*p_phFV(4,4);
    v89=[v89x,v89y];
    P89=Pe(1)*p_phFV(4,1)+Pe(2)*p_phFV(4,2)+Pe(3)*p_phFV(4,3)+Pe(4,1)*p_phFV(4,4);   
    
    p_dVel59=zeros(2,2); p_dVel69=zeros(2,2);
    p_dVel79=zeros(2,2); p_dVel89=zeros(2,2);

    for i=1:1:dim
        for I=1:1:nde
            for j=1:1:dim          
                p_dVel59(i,j)=p_dVel59(i,j)+p_JdphFV(I,j,1)*ue(I,i);     %[Element Variable] Derivative of Velocity (dvdx)
                p_dVel69(i,j)=p_dVel69(i,j)+p_JdphFV(I,j,2)*ue(I,i);
                p_dVel79(i,j)=p_dVel79(i,j)+p_JdphFV(I,j,3)*ue(I,i);
                p_dVel89(i,j)=p_dVel89(i,j)+p_JdphFV(I,j,4)*ue(I,i);
            end
        end
    end

        
    sig59=zeros(2,2); sig69=zeros(2,2);
    sig79=zeros(2,2); sig89=zeros(2,2);
    for i=1:1:dim
        for j=1:1:dim
            sig59(i,j)=sig59(i,j)+(-P59)*delk(i,j)+mu*(p_dVel59(i,j)+p_dVel59(j,i));
            sig69(i,j)=sig69(i,j)+(-P69)*delk(i,j)+mu*(p_dVel69(i,j)+p_dVel69(j,i));
            sig79(i,j)=sig79(i,j)+(-P79)*delk(i,j)+mu*(p_dVel79(i,j)+p_dVel79(j,i));
            sig89(i,j)=sig89(i,j)+(-P89)*delk(i,j)+mu*(p_dVel89(i,j)+p_dVel89(j,i));
        end
    end
    fc=zeros(4,2);    fm=zeros(4,2);    mf=zeros(4,1);
    for i=1:1:dim
        for j=1:1:dim
            fc(1,j)=fc(1,j)+(-rho)*v59(i)*v59(j)*-n59(j)*L59-rho*v89(i)*v89(j)*n89(j)*L89;
            fm(1,j)=fm(1,j)+sig59(j,i)*-n59(j)*L59+sig89(j,i)*n89(j)*L89;
            fc(2,j)=fc(2,j)+(-rho)*v69(i)*v69(j)*-n69(j)*L69-rho*v59(i)*v59(j)*n59(j)*L59;
            fm(2,j)=fm(2,j)+sig69(j,i)*-n69(j)*L69+sig59(j,i)*n59(j)*L59;
            fc(3,j)=fc(3,j)+(-rho)*v79(i)*v79(j)*-n79(j)*L79-rho*v69(i)*v69(j)*n69(j)*L69;
            fm(3,j)=fm(3,j)+sig79(j,i)*-n79(j)*L79+sig69(j,i)*n69(j)*L69;
            fc(4,j)=fc(4,j)+(-rho)*v89(i)*v89(j)*-n89(j)*L89-rho*v79(i)*v79(j)*n79(j)*L79;
            fm(4,j)=fm(4,j)+sig89(j,i)*-n89(j)*L89+sig79(j,i)*n79(j)*L79;
            
            mf(1)=mf(1)+(-rho/cr)*(v59(i)*-n59(i)*L59)-rho/cr*(v89(i)*n89(i)*L89);
            mf(2)=mf(2)+(-rho/cr)*(v69(i)*-n69(i)*L69)-rho/cr*(v59(i)*n59(i)*L59);
            mf(3)=mf(3)+(-rho/cr)*(v79(i)*-n79(i)*L79)-rho/cr*(v69(i)*n69(i)*L69);
            mf(4)=mf(4)+(-rho/cr)*(v89(i)*-n89(i)*L89)-rho/cr*(v79(i)*n79(i)*L79);
        end
    end
    
%     fc;
%     fm;
%     mf;
    
end