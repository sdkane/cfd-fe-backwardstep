%Element Pressure Velocity From Global Pressure Velocity Matrix
function [ue,Pe] = ElementPV(ConM,v,P,LPS)
    
    ue=[v(ConM(LPS,1),1),v(ConM(LPS,1),2);...
        v(ConM(LPS,2),1),v(ConM(LPS,2),2);...
        v(ConM(LPS,3),1),v(ConM(LPS,3),2);...
        v(ConM(LPS,4),1),v(ConM(LPS,4),2)];
    
    Pe=[P(ConM(LPS,1),1);...
        P(ConM(LPS,2),1);...
        P(ConM(LPS,3),1);...
        P(ConM(LPS,4),1)];

end

%This assumes that the velocity matrix is layed out as follows
%Rows correspond to global node number
%Columns corresppond to (x,y) velocities
%ConM(LPS,#) Finds us the correct row to correspond to the element
%The # is the local node number

%CALLED BY: ElementMatrices
%CALLS: -