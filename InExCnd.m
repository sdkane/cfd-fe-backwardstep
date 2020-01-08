%Finite Volume Only
%Applies Extra Node Condtions at the Inlet and Exit to Create Mass Balance
function [fc,fm,mf]=InExCnd(InNd,ExNd,ConM,LV,p_phFVie,p_JdphFVie,v,P,fc,fm,mf,rho,mu,cr)
    
    [~,inms]=size(InNd);
    for lps=1:1:inms+1
        if lps<=inms; InNd(lps)=InNd(lps); end
        if lps==inms+1; InNd(lps)=InNd(1)+InNd(inms); end
    end
    
    [~,enms]=size(ExNd);
    for lps=1:1:enms+1
        if lps<=enms; ExNd(lps)=ExNd(lps); end
        if lps==enms+1; ExNd(lps)=ExNd(enms)+(ExNd(enms)-ExNd(enms-1)); end
    end

    [~,inms]=size(InNd);
    [~,enms]=size(ExNd);
    [cnms,~]=size(ConM);
    
    dim=2; nde=4;
    delk=eye(dim); %Delta Kronecker
    otr=max(inms,enms); %More inlet or more outlet nodes
    
    L48=LV(1); L18=LV(1); L36=LV(1); L26=LV(1);
    n48=[1,0]; n18=[-1,0]; n36=[1,0]; n26=[-1,0];
    
%     fc(:,:,30)
%     mf(:,30)
    
    for ii=1:1:otr
        for LPS=1:1:cnms
            %Inlet
            if ii<=inms
                if ConM(LPS,1)==InNd(ii)

                    [ue,Pe]=ElementPV(ConM,v,P,LPS);

                    v48x=ue(1,1)*p_phFVie(2,1)+ue(2,1)*p_phFVie(2,2)+ue(3,1)*p_phFVie(2,3)+ue(4,1)*p_phFVie(2,4);   %ph(1,#) is ph(pt59,ph#)
                    v48y=ue(1,2)*p_phFVie(2,1)+ue(2,2)*p_phFVie(2,2)+ue(3,2)*p_phFVie(2,3)+ue(4,2)*p_phFVie(2,4);
                    v48=[v48x,v48y];
                    P48=Pe(1)*p_phFVie(2,1)+Pe(2)*p_phFVie(2,2)+Pe(3)*p_phFVie(2,3)+Pe(4,1)*p_phFVie(2,4);

                    v18x=ue(1,1)*p_phFVie(1,1)+ue(2,1)*p_phFVie(1,2)+ue(3,1)*p_phFVie(1,3)+ue(4,1)*p_phFVie(1,4);   %ph(1,#) is ph(pt59,ph#)
                    v18y=ue(1,2)*p_phFVie(1,1)+ue(2,2)*p_phFVie(1,2)+ue(3,2)*p_phFVie(1,3)+ue(4,2)*p_phFVie(1,4);
                    v18=[v18x,v18y];
                    P18=Pe(1)*p_phFVie(1,1)+Pe(2)*p_phFVie(1,2)+Pe(3)*p_phFVie(1,3)+Pe(4,1)*p_phFVie(1,4);

                    p_dVel48=zeros(2,2); p_dVel18=zeros(2,2);
                    for i=1:1:dim
                        for I=1:1:nde
                            for j=1:1:dim          
                                p_dVel48(i,j)=p_dVel48(i,j)+p_JdphFVie(I,j,2)*ue(I,i);
                                p_dVel18(i,j)=p_dVel18(i,j)+p_JdphFVie(I,j,1)*ue(I,i);
                            end
                        end
                    end

                    sig48=zeros(2,2); sig18=zeros(2,2);
                    for i=1:1:dim
                        for j=1:1:dim
                            sig48(i,j)=sig48(i,j)+(-P48)*delk(i,j)+mu*(p_dVel48(i,j)+p_dVel48(j,i));
                            sig18(i,j)=sig18(i,j)+(-P18)*delk(i,j)+mu*(p_dVel18(i,j)+p_dVel18(j,i));
                        end
                    end

                    for i=1:1:dim
                        for j=1:1:dim
                            fc(1,j,LPS)=fc(1,j,LPS)+(-rho)*v18(i)*v18(j)*-n18(j)*L18;
                            fm(1,j,LPS)=fm(1,j,LPS)+sig18(j,i)*-n18(j)*L18;
                            mf(1,LPS)=mf(1,LPS)+(-rho/cr)*(v18(i)*-n18(i)*L18);

                            fc(4,j,LPS)=fc(4,j,LPS)+(-rho)*v48(i)*v48(j)*n48(j)*L48;
                            fm(4,j,LPS)=fm(4,j,LPS)+sig48(j,i)*n48(j)*L48;
                            mf(4,LPS)=mf(4,LPS)+(-rho/cr)*(v48(i)*n48(i)*L48);
                        end
                    end
                end
            end
            
            %Exit
            if ii<=enms
                if ConM(LPS,2)==ExNd(ii)

                    [ue,Pe]=ElementPV(ConM,v,P,LPS);

                    v36x=ue(1,1)*p_phFVie(4,1)+ue(2,1)*p_phFVie(4,2)+ue(3,1)*p_phFVie(4,3)+ue(4,1)*p_phFVie(4,4);   %ph(1,#) is ph(pt59,ph#)
                    v36y=ue(1,2)*p_phFVie(4,1)+ue(2,2)*p_phFVie(4,2)+ue(3,2)*p_phFVie(4,3)+ue(4,2)*p_phFVie(4,4);
                    v36=[v36x,v36y];
                    P36=Pe(1)*p_phFVie(4,1)+Pe(2)*p_phFVie(4,2)+Pe(3)*p_phFVie(4,3)+Pe(4,1)*p_phFVie(4,4);

                    v26x=ue(1,1)*p_phFVie(3,1)+ue(2,1)*p_phFVie(3,2)+ue(3,1)*p_phFVie(3,3)+ue(4,1)*p_phFVie(3,4);   %ph(1,#) is ph(pt59,ph#)
                    v26y=ue(1,2)*p_phFVie(3,1)+ue(2,2)*p_phFVie(3,2)+ue(3,2)*p_phFVie(3,3)+ue(4,2)*p_phFVie(3,4);
                    v26=[v26x,v26y];
                    P26=Pe(1)*p_phFVie(3,1)+Pe(2)*p_phFVie(3,2)+Pe(3)*p_phFVie(3,3)+Pe(4,1)*p_phFVie(3,4);
                    
                    p_dVel26=zeros(2,2); p_dVel36=zeros(2,2);
                    for i=1:1:dim
                        for I=1:1:nde
                            for j=1:1:dim          
                                p_dVel26(i,j)=p_dVel26(i,j)+p_JdphFVie(I,j,3)*ue(I,i);
                                p_dVel36(i,j)=p_dVel36(i,j)+p_JdphFVie(I,j,4)*ue(I,i);
                            end
                        end
                    end

                    sig36=zeros(2,2); sig26=zeros(2,2);
                    for i=1:1:dim
                        for j=1:1:dim
                            sig36(i,j)=sig36(i,j)+(-P36)*delk(i,j)+mu*(p_dVel36(i,j)+p_dVel36(j,i));
                            sig26(i,j)=sig26(i,j)+(-P26)*delk(i,j)+mu*(p_dVel26(i,j)+p_dVel26(j,i));
                        end
                    end
                    
                    for i=1:1:dim
                        for j=1:1:dim
                            fc(2,j,LPS)=fc(2,j,LPS)+(-rho)*v26(i)*v26(j)*n26(j)*L26;
                            fm(2,j,LPS)=fm(2,j,LPS)+sig26(j,i)*n26(j)*L26;
                            mf(2,LPS)=mf(2,LPS)+(-rho/cr)*(v26(i)*n26(i)*L26);

                            fc(3,j,LPS)=fc(3,j,LPS)+(-rho)*v36(i)*v36(j)*-n36(j)*L36;
                            fm(3,j,LPS)=fm(3,j,LPS)+sig36(j,i)*-n36(j)*L36;
                            mf(3,LPS)=mf(3,LPS)+(-rho/cr)*(v36(i)*-n36(i)*L36);
                        end
                    end
                end
            end
            
        end
    end
%     fc(:,:,30);
%     fm;
%     mf(:,30)
%     'Next'
end