%Connectivity Matrix
%Incrementing Global Node Numbers Left to Right Than Down One Row
%Rectangular Mesh Layout
function [ConM] = ConnectMatrix(NELXY,BSTEL)
    
    NdRm=BSTEL(1)*BSTEL(2);
          
    Ndx=NELXY(1)+1;                                                         %Nodes in X
    Ndy=NELXY(2)+1;                                                         %Nodes in Y
    
    if NdRm ~= 0
        BsNdx=BSTEL(1)+1;                                                   %Backward Step Nodes
        BsNdy=BSTEL(2)+1;
        stct=(NELXY(2)-BSTEL(2))*NELXY(1);                                  %Step Count, When the Step Happens
    else
        stct=0;
    end
    
    lcl1=Ndx+1; lcl2=Ndx+2;                                                 %Initializing Count Start Points
    lcl3=2;     lcl4=1;
    
    nct=0;                                                                  %Initializing Incrementer
    rwct=NELXY(1); rwpl=rwct;                                               %Incrementer For End of Row Operations (RowCount / RowPlus)
    
    
    ConM=zeros(NELXY(1)*NELXY(2)-NdRm,4);                                   %Empty Matrix For Output
    for LPS=1:1:(NELXY(1)*NELXY(2)-NdRm)
    
        ConM(LPS,1)=lcl1+nct;                                               %Counting Up
        ConM(LPS,2)=lcl2+nct;
        ConM(LPS,3)=lcl3+nct;
        ConM(LPS,4)=lcl4+nct;
        
        nct=nct+1;                                                          %Incrementing Incrementer
        if LPS==rwct; nct=nct+1; rwct=rwct+rwpl; end                        %Accounting For Nodal Jumps at End of Rows
        
        if LPS==stct
            stct=0;                                                         %Prevent Incrementation From Recurring
            lcl3=lcl3+BSTEL(1);                                                
            lcl4=lcl4+BSTEL(1);
            rwct=rwct-BSTEL(1);
            rwpl=rwpl-BSTEL(1);
        end
                
    end
    
end

%CALLED BY: GlobalSolver
%CALLS: -