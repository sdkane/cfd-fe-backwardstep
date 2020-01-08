%Boundary Nodes 
function [BndNds] = BoundaryNodes(NELXY,BSTEL)
    
    NdsX=NELXY(1)+1;
    NdsY=NELXY(2)+1;
    TTLPS=NdsX*NdsY-BSTEL(1)*BSTEL(2);
    
    CND1=NdsX+1+NdsX*(NELXY(2)-BSTEL(2)-1);
    CND2=CND1+BSTEL(1);
    
    CND3=NELXY(1)-BSTEL(1)+1;
    mlt=1;
    
    bncn=1;
    
    for LPS=1:1:TTLPS
        if LPS <= NdsX
            BndNds(bncn)=LPS;
            bncn=bncn+1;   
            
        elseif LPS >= CND1 && LPS <= CND2
            BndNds(bncn)=LPS;
            bncn=bncn+1;
            
        elseif LPS==CND2+CND3*mlt 
            BndNds(bncn)=LPS;
            mlt=mlt+1; bncn=bncn+1;
            
        elseif LPS >= TTLPS-(NELXY(1)-BSTEL(1))
            BndNds(bncn)=LPS;
            bncn=bncn+1;
            
        end
        
    end
    
end