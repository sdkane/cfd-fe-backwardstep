%Streamlines v3
%Start Point Global XY
%Calculate New Point from small dt
%Find element it is within
%ConM look at local n1 XY evaluate if xy within boundaries
%convert global to element
function StreamLine_v3(InNd,ConM,NELXY,MshXY,XYCoords,v)

    [cnms,~]=size(ConM);

    ElX=MshXY(1)/NELXY(1);
    ElY=MshXY(2)/NELXY(2);

    tst=0.01;                   %Time Step Value
    rnt=100000;                 %Number of Steps
    
    nsdpts=13;
    
    %Define Seedpoints Based off whatever point you want, I used the inlet
    %nodes for convenience as they are easy to see.
    xsdpts=[XYCoords(InNd(1),1),...
            XYCoords(InNd(2),1),...
            XYCoords(InNd(3),1),...
            XYCoords(InNd(4),1),...
            XYCoords(InNd(5),1),...
            XYCoords(InNd(5),1)+6.5*ElX,...
            XYCoords(InNd(5),1)+6.5*ElX,...
            XYCoords(InNd(5),1)+9*ElX,...
            XYCoords(InNd(5),1)+11*ElX,...
            XYCoords(InNd(1),1),...
            XYCoords(InNd(1),1),...
            XYCoords(InNd(1),1)+12*ElX,...
            XYCoords(InNd(1),1)+10*ElX,...
            XYCoords(InNd(1),1)+14*ElX];
        
    ysdpts=[XYCoords(InNd(1),2),...
            XYCoords(InNd(2),2),...
            XYCoords(InNd(3),2),...
            XYCoords(InNd(4),2),...
            XYCoords(InNd(5),2),...
            XYCoords(InNd(5),2)-2.5*ElY,...
            XYCoords(InNd(5),2)-4*ElY,...
            XYCoords(InNd(5),2)-5.5*ElY,...
            XYCoords(InNd(5),2)-6*ElY,...
            XYCoords(InNd(1),2)+0.5*ElY,...
            XYCoords(InNd(5),2)-0.5*ElY,...
            XYCoords(InNd(1),2)+0.5*ElY,...
            XYCoords(InNd(5),2)-6.5*ElY,...
            XYCoords(InNd(5),2)-5*ElY];

%     nsdpts=1;
%     xsdpts=[XYCoords(InNd(1),1)+0.5*ElX];
%     ysdpts=[XYCoords(InNd(1),2)+0.5*ElY];

    tic
    for ii=1:1:nsdpts
        
        oxps=xsdpts(ii);   %Seed Point X
        oyps=ysdpts(ii);   %Seed Point Y
        
        hold on
        plot(oxps,oyps,'o','Color',[0,0,0],'MarkerSize',5.5,'MarkerFaceColor',[0,0,0]) %Put a dot at the seed point
        
        for tme=1:1:rnt
            for ELS=1:1:cnms

                Rx=XYCoords(ConM(ELS,2),1);
                Lx=XYCoords(ConM(ELS,1),1);
                Uy=XYCoords(ConM(ELS,3),2);
                Dy=XYCoords(ConM(ELS,1),2);
                
                if oxps<Rx || oxps==Rx %I had this as one if statment but broke it apart during debugging and just never changed it back
                   if oxps>Lx || oxps==Lx 
                        if oyps<Uy || oyps==Uy 
                            if oyps>Dy || oyps==Dy  %If the coordinate lies within the element
                                                              
                                nxc=2*oxps/Rx-1;
                                nyc=2*oyps/Uy-1;

                                phps=Cmpt('Phi',[nxc,nyc]);

                                vx=v(ConM(ELS,1),1)*phps(1)+v(ConM(ELS,2),1)*phps(2)+v(ConM(ELS,3),1)*phps(3)+v(ConM(ELS,4),1)*phps(4); %Coordinate Velocity
                                vy=v(ConM(ELS,1),2)*phps(1)+v(ConM(ELS,2),2)*phps(2)+v(ConM(ELS,3),2)*phps(3)+v(ConM(ELS,4),2)*phps(4);

                                nxps=oxps+tst*vx; 
                                nyps=oyps+tst*vy;
                                
%                                 if nxps<oxps; cl=[0,0,1]; %Coloring option to have positive or negative directon flow colored differently
%                                 else cl=[1,0,0]; end
                                
                                line([oxps,nxps],[oyps,nyps],'Color',[1,0,0],'LineWidth',2.5);

                                oxps=nxps;  %Sets the new as the old 
                                oyps=nyps;
                                ELS=cnms;   %Ends looping through elements allow us to start again
                                if oxps>MshXY(1); tme=rnt; end %Break the loop if we are outside the exit nodes
                            end
                        end
                    end
                end
            end
            if tme==1000 && ii==1
                tme=toc;
                fprintf('<> Render Time Estimate: %0.0fmin\n',tme*rnt/1000/60*nsdpts)%
            end
        end
    end
%     oxps
%     oyps
%     vx
%     vy
    ttm=toc;
    fprintf('<> Render Complete <>\n')
    fprintf('<> Total Render Time: %0.0fmin <>\n',ttm/60)
end
