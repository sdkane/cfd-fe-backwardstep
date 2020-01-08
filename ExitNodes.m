%Defining Exit Nodes
function [ExNd]=ExitNodes(NELXY,BSTEL)
    
    rws=NELXY(2)-BSTEL(2);
    rwspl=NELXY(2)-1;
    NdsX=NELXY(1)+1;
    
    incr=NELXY(1)-BSTEL(1)+1;
    cnt=1;
    
    ExNd=zeros(1,rws);
    for lps=1:1:rws
        ExNd(lps)=NdsX*(1+lps);
    end
    
    for lps=(rws+1):1:rwspl
        ExNd(lps)=ExNd(rws)+incr*cnt;
        cnt=cnt+1;
    end
end