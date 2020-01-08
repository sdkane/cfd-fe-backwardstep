%Define Inlet Nodes
function [InNd] = InletNodes(NELXY,BSTEL)
    
    rws=NELXY(2)-BSTEL(2)-1;
    NdsX=NELXY(1)+1;
    
    InNd=zeros(1,rws);
    for lps=0:1:rws-1
        InNd(lps+1)=NdsX*(1+lps)+1;
    end
    
end


%     rws=NELXY(2)-BSTEL(2)-1;
%     NdsX=NELXY(1)+1;
%     
%     InNd=zeros(1,rws);
%     for rws=0:1:rws-1
%         InNd(rws+1)=NdsX*(1+rws)+1;
%     end