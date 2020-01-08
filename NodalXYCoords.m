%XY Coordinates of Each Global Node
function [XYCoords] = NodalXYCoords(NELXY,BSTEL,MshXY)
    NdsX=NELXY(1)+1;                        %Nodes in X
    NdsY=NELXY(2)+1;                        %Nodes in Y
    TLNds=NdsX*NdsY-BSTEL(1)*BSTEL(2);      %Total Nodes in Mesh

    ElX=MshXY(1)/NELXY(1);                  %Element Width
    ElY=MshXY(2)/NELXY(2);                  %Element Height

    TWidth=MshXY(1);                        %Total Width of System

    xcnt=0;     %X Incrementer
    ycnt=0;     %Y Incrementer
    stoft=0.0;    %Step Offset;

    ee=0.99;
    efr1=1-ee; efr2=1+ee;
    
    XYCoords=zeros(TLNds,2);
    for LPS=1:1:TLNds
        if  (xcnt-1)*ElX>=(TWidth-stoft)*0.99 && ycnt*ElY>=(MshXY(2)-BSTEL(2)*ElY)*0.99 %If at Beginning of Step
            xcnt=0;
            ycnt=ycnt+1;
            stoft=BSTEL(1)*ElX;                                             %How much to adjust for the step
        elseif (xcnt-1)*ElX+stoft>=TWidth*0.99                                    %If at any other end of a Row
            xcnt=0;
            ycnt=ycnt+1;
        end

        XYCoords(LPS,1)=xcnt*ElX+stoft;
        XYCoords(LPS,2)=NELXY(2)*ElY-ycnt*ElY;
        xcnt=xcnt+1;        
    end
    
    
    
end





%     for LPS=1:1:TLNds
%         if  (xcnt-1)*ElX>=(TWidth-stoft)*efr1 && (xcnt-1)*ElX<=(TWidth-stoft)*efr2 && ycnt*ElY>=(MshXY(2)-BSTEL(2)*ElY)*efr1 && ycnt*ElY<=(MshXY(2)-BSTEL(2)*ElY)*efr2 %If at Beginning of Step
%             'act1'
%             xcnt=0;
%             ycnt=ycnt+1;
%             stoft=BSTEL(1)*ElX;                                             %How much to adjust for the step
%         elseif  (xcnt-1)*ElX+stoft>=TWidth*0.95 && (xcnt-1)*ElX+stoft==TWidth*1.05                                  %If at any other end of a Row
%             'act2'
%             xcnt=0;
%             ycnt=ycnt+1;
%         end
% 
%         XYCoords(LPS,1)=xcnt*ElX+stoft;
%         XYCoords(LPS,2)=NELXY(2)*ElY-ycnt*ElY;
%         xcnt=xcnt+1;        
%     end