%Boundary Conditions
function [v,P] = BndCnd(BndNds,v,P)
    [~,bnds]=size(BndNds);
    
    for LPS=1:1:bnds
       v(BndNds(LPS),:)=0;
%        P(BndNds(LPS))=0; %Free pressure at walls
    end


end