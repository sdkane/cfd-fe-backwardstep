%Setting Exit Pressures to Zero
function [P] = PresExit(ExNd,P)
    [enms,~]=size(ExNd);
    
    for LPS=1:1:enms
        P(ExNd(LPS))=0;
    end
end

