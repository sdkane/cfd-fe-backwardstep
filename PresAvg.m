%Pressure Averaging
function [P] = PresAvg(AdjNds,NELXY,BSTEL,P)
    NdsX=NELXY(1)+1;
    NdsY=NELXY(2)+1;
    TLNds=NdsX*NdsY-BSTEL(1)*BSTEL(2);
    wcn=0.9625;
    
    for LPS=1:1:TLNds
        zrs=sum(~AdjNds(LPS,:));
        switch zrs
            case 0; wgh=0.009375;
            case 1; wgh=0.0125;
            case 2; wgh=0.01875; 
            case 3; wgh=0.00375; end
        waj=[wgh,wgh,wgh,wgh];

        if AdjNds(LPS,1)==0; P1=0;
        else P1=P(AdjNds(LPS,1)); end
        
        if AdjNds(LPS,2)==0; P2=0; 
        else P2=P(AdjNds(LPS,2)); end
        
        if AdjNds(LPS,3)==0; P3=0; 
        else P3=P(AdjNds(LPS,3)); end
        
        if AdjNds(LPS,4)==0; P4=0; 
        else P4=P(AdjNds(LPS,4)); end

        P(LPS)=waj(1)*P1+waj(2)*P2+waj(3)*P3+waj(4)*P4+wcn*P(LPS);
    end
    
end
