%Determines Element Size from Number of Mesh Elements and MshXY Coordinates
function [xe] = ElementSize(MshXY,NELXY)
    xe(1,1)=0;                          xe(1,2)=0;
    xe(2,1)=MshXY(1)/NELXY(1);          xe(2,2)=0;
    xe(3,1)=MshXY(1)/NELXY(1);          xe(3,2)=MshXY(2)/NELXY(2);
    xe(4,1)=0;                          xe(4,2)=MshXY(2)/NELXY(2);
end
%Assumes that it is a uniform element sizing

%CALLED BY: GlobalConstants
%CALLS: -