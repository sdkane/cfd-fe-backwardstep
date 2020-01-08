%Plotting Mesh
%Visualization of Flow Area
function PlotMeshGrid(NELXY,BSTEL,MshXY)
    NdsX=NELXY(1)+1;    %Nodes in X
    NdsY=NELXY(2)+1;    %Nodes in Y

    ElX=MshXY(1)/NELXY(1);                  %Element Width
    ElY=MshXY(2)/NELXY(2);                  %Element Height

    BsX=BSTEL(1)*ElX;                       %Total Backstep Width
    BsY=BSTEL(2)*ElY;                       %Total Backstep Height

    TWidth=MshXY(1);
    THeight=MshXY(2);

    cnt=0;
    axis([-ElX,TWidth+ElX,-ElY,THeight+ElY]);
    for LPS=1:1:NdsY                        %Plotting X-Direction Lines
        if THeight-LPS*ElY+ElY >= BsY-0.05*BsY      %-0.05*BsY because Matlab does not store the variables to a high enough precision for small grids
            LineH=THeight-cnt*ElY;                          %Line Height
            cnt=cnt+1;
            line([0,TWidth],[LineH,LineH],'Color',[0,0,0]);
        else
            LineH=THeight-cnt*ElY;                          %Line Height
            cnt=cnt+1;
            line([BsX,TWidth],[LineH,LineH],'Color',[0,0,0]);
        end
    end

    
    cnt=0;
    for LPS=1:1:NdsX                        %Plotting Y-Direction Lines
        if TWidth-LPS*ElX+ElX >= BsX-0.05*BsX%-ElX
            LineW=TWidth-cnt*ElX;
            cnt=cnt+1;
            line([LineW,LineW],[0,THeight],'Color',[0,0,0]);
        else
            LineW=TWidth-cnt*ElX;
            cnt=cnt+1;
            line([LineW,LineW],[BsY,THeight],'Color',[0,0,0]);
        end
    end
    
end