%Adjacent Nodes
function [AdjNds] = AdjacentNodes(NELXY,BSTEL)

    NdsX=NELXY(1)+1;
    NdsY=NELXY(2)+1;
    TLNds=NdsX*NdsY-BSTEL(1)*BSTEL(2);
    
    if BSTEL(2)>0; chk=1;
    else chk=0; end
    CND1=NdsX*(NdsY-BSTEL(2))-chk*NELXY(1);
    cnt=1;
    rst1=0;
       
    AdjNds=zeros(TLNds,4);
    for LPS=1:1:TLNds
        
        if LPS < CND1 %Before Step Reached
       
            if LPS == NdsX*cnt  %If end of Row
                AdjNds(LPS,1)=LPS-NdsX;
                AdjNds(LPS,2)=LPS-1;
                AdjNds(LPS,3)=0;
                AdjNds(LPS,4)=LPS+NdsX;
                if LPS==TLNds; AdjNds(LPS,4)=0; end
            elseif LPS == (NdsX*cnt+1) %If Beginning of Row
                AdjNds(LPS,1)=LPS-NdsX;
                AdjNds(LPS,2)=0;
                AdjNds(LPS,3)=LPS+1;
                AdjNds(LPS,4)=LPS+NdsX;
                if LPS==TLNds-NELXY(1); AdjNds(LPS,4)=0; end
                cnt=cnt+1;
            elseif LPS > NdsX*NELXY(2) %If Last Row
                AdjNds(LPS,1)=LPS-NdsX;
                AdjNds(LPS,2)=LPS-1;
                AdjNds(LPS,3)=LPS+1; 
                AdjNds(LPS,4)=0;
            else %Everything Else
                AdjNds(LPS,1)=LPS-NdsX;
                AdjNds(LPS,2)=LPS-1;
                AdjNds(LPS,3)=LPS+1;
                AdjNds(LPS,4)=LPS+NdsX;
            end
               
        elseif LPS >= CND1 && LPS <= CND1+BSTEL(1)-1 %Elements Directly Above Step
                        
            if LPS == (NdsX*cnt+1)
                AdjNds(LPS,1)=LPS-NdsX;
                AdjNds(LPS,2)=0;
                AdjNds(LPS,3)=LPS+1;
                AdjNds(LPS,4)=0;
                cnt=cnt+1;
            else
                AdjNds(LPS,1)=LPS-NdsX;
                AdjNds(LPS,2)=LPS-1;
                AdjNds(LPS,3)=LPS+1;
                AdjNds(LPS,4)=0;
            end
            
        elseif LPS > CND1+BSTEL(1)-1 && LPS <=  CND1+NELXY(1)
            
            if LPS == NdsX*cnt  %If end of Row
                AdjNds(LPS,1)=LPS-NdsX+rst1;
                AdjNds(LPS,2)=LPS-1;
                AdjNds(LPS,3)=0;
                AdjNds(LPS,4)=LPS+NdsX-BSTEL(1);
                if LPS==TLNds; AdjNds(LPS,4)=0; end
            elseif LPS == NdsX*cnt+1 %If Beginning of Row
                AdjNds(LPS,1)=LPS-NdsX+rst1;
                AdjNds(LPS,2)=0;
                AdjNds(LPS,3)=LPS+1;
                AdjNds(LPS,4)=LPS+NdsX-BSTEL(1);
                if LPS==TLNds-NELXY(1); AdjNds(LPS,4)=0; end
                cnt=cnt+1;
            elseif LPS > NdsX*NELXY(2) %If Last Row
                AdjNds(LPS,1)=LPS-NdsX+rst1;
                AdjNds(LPS,2)=LPS-1;
                AdjNds(LPS,3)=LPS+1; 
                AdjNds(LPS,4)=0;
            else %Everything Else
                AdjNds(LPS,1)=LPS-NdsX+rst1;
                AdjNds(LPS,2)=LPS-1;
                AdjNds(LPS,3)=LPS+1;
                AdjNds(LPS,4)=LPS+NdsX-BSTEL(1);
            end
            
                
        elseif LPS > CND1+NELXY(1)
            
            if LPS==CND1+NELXY(1)+1;
               CND2=LPS+NELXY(1)-BSTEL(1);
               cnt2=1;
               rst1=BSTEL(1);
            end
            
            if LPS == CND2*(cnt2-1) %If end of Row
                AdjNds(LPS,1)=LPS-NdsX+rst1;
                AdjNds(LPS,2)=LPS-1;
                AdjNds(LPS,3)=0;
                AdjNds(LPS,4)=LPS+NdsX-rst1;
            elseif LPS == CND2-(NELXY(1)-BSTEL(1))+(cnt2-1)*(NdsX-BSTEL(1))                   %If Beginning of Row
                AdjNds(LPS,1)=LPS-NdsX+rst1;
                AdjNds(LPS,2)=0;
                AdjNds(LPS,3)=LPS+1;
                AdjNds(LPS,4)=LPS+NdsX-BSTEL(1);
                if LPS==TLNds-NELXY(1); AdjNds(LPS,4)=0; end
                cnt2=cnt2+1;
            else                                        %Everything Else
                AdjNds(LPS,1)=LPS-NdsX+rst1;
                AdjNds(LPS,2)=LPS-1;
                AdjNds(LPS,3)=LPS+1;
                AdjNds(LPS,4)=LPS+NdsX-BSTEL(1);
            end
            
        end
    end
    
    for LPS=1:1:TLNds                                                       %Eliminating Nodes Over at End Row
        if AdjNds(LPS,1)>TLNds; AdjNds(LPS,1)=0; end
        if AdjNds(LPS,2)>TLNds; AdjNds(LPS,2)=0; end
        if AdjNds(LPS,3)>TLNds; AdjNds(LPS,3)=0; end
        if AdjNds(LPS,4)>TLNds; AdjNds(LPS,4)=0; end
    end
    
    AdjNds=max(AdjNds,0);    
end     