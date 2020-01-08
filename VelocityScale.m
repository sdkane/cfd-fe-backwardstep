%Velocity Scaling and Compressibility Factor
function [v,cr] = VelocityScale(InNd,v,umax,pptst,MaNu,chln,grsz,tme)
    
    [~,ins]=size(InNd);
    
    ustp=pptst*tme;
    if ustp > umax
        ustp=umax;
        
    end
        
    if mod(ins,2) == 0
        mns=1;
        for LPS=(ins/2+1):1:ins
            v(InNd(LPS),1)=ustp*(1-((grsz*LPS)/chln)^2);
            v(InNd(LPS-mns),1)=v(InNd(LPS),1);
            mns=mns+1;
        end
        
    else
        mns=2;
        for LPS=(ceil(ins/2)+1):1:ins
            v(InNd(LPS),1)=ustp*(1-((grsz*LPS)/chln)^2);
            v(InNd(LPS-mns),1)=v(InNd(LPS),1);
        end
        v(InNd(ceil(ins/2)),1)=ustp;
    end
    cr=1/((ustp/MaNu)^2);
end    
    
    
    
%     
%     if ustp < umax
%         for LPS=1:1:ins
%             v(InNd(LPS),1)=ustp*(1-((grsz*LPS)/chln)^2);    
%             cr=1/((ustp/MaNu)^2);
%         end
% %     else
% %         for LPS=1:1:ins
% %             v(InNd(LPS),1)=umax*(1-((grsz*LPS)/chln)^2);
% %             cr=1/((umax/MaNu)^2);
% %         end        
%     end
% 
%     umax*(1-(y/H)^2
%     
%     
% %             for x=-chln:0.01:chln
% %                 xp(cnt)=ustp*(1-((x)/chln)^2);
% %                 cnt=cnt+1;
% %             end
% %             x=-chln:0.01:chln;
% %             size(x)
% %             size(xp)
% %             plot(x,xp)
% 
%     
%     
% %     if ustp < umax
% %         xtot=2*sqrt(ustp);
% %         for LPS=1:1:ins
% % %             v(InNd(LPS),1)=convrat*sqrt(ustp)*(ustp-(LPS*grsz)^2/4);
% %             v(InNd(LPS),1)=cinv/sqrt(ustp)*(ustp-(xtot/(ins+2)*(ins+1)+sqrt(4*ustp))^2/4);
% %             cr=1/((ustp/MaNu)^2);
% %         end
% %     else
% %         xtot=2*sqrt(umax);
% %         for LPS=1:1:ins
% % %             v(InNd(LPS),1)=convrat*sqrt(umax)*(umax-(LPS*grsz)^2/4);
% %             v(InNd(LPS),1)=cinv/sqrt(umax)*(umax-(LPS*grsz)^2/4);
% %             cr=1/((umax/MaNu)^2);
% %         end  
% %     end
%         
% end
% 
% 
% %u(y)=u_max*(1-(y/H)^2) and u_avg=.66667u_max
% %they messed up where they put the 3/2, and it was some universities website!
% %anyway, in this case their H is 1/2 of our h with the origin at the  center between the two plates