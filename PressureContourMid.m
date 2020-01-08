function PressureContourMid(P,XYCoords,ConM,MshXY,NELXY)
    fprintf('<> Rendering Pressure Contour <>\n');
    [Pnms,~]=size(P);
    [cnms,~]=size(ConM);
        
    pmvm=0.25;%0.15;
    
    Pm_avg=mean(P);
    Pm_std=std(P);
    
    %Setting Up Evaluation Points Within an Element for Interpolation
    
    stp=0.05;
    rns=2/stp+1;
    
    fprintf('<> Points Per Element %0.0f\n',ceil(rns*rns));
    fprintf('<> Total Points %0.0f\n',ceil(rns*rns)*Pnms);
        
    ElXad=MshXY(1)/NELXY(1)/rns;
    ElYad=MshXY(2)/NELXY(2)/rns;
    
    itr1=0; itr2=0;
    evalpts=zeros(rns,2,rns);
    for j=1:1:rns
        for i=1:1:rns
            evalpts(i,1,j)=-1+itr2;
            evalpts(i,2,j)=-1+itr1;
            itr2=itr2+stp;
        end
        itr1=itr1+stp;
        itr2=0;
    end
    
    %Evaluating Points Using Shape Functions
    phi=zeros(rns,4,rns);
    for j=1:1:rns
        for i=1:1:rns
            phi(i,:,j)=Cmpt('Phi',evalpts(i,:,j));
        end
    end
        
    indicm='s';
    
    hold on
    tic
    for LPS=1:1:cnms     %Looping Through Elements
        P1=P(ConM(LPS,1));    %Nodal Velocities for the Element
        P2=P(ConM(LPS,2));
        P3=P(ConM(LPS,3));
        P4=P(ConM(LPS,4));
        
        xps=XYCoords(ConM(LPS),1); %Local Node 1 X-Position
        yps=XYCoords(ConM(LPS),2); %Local Node 1 Y-Position
        
        xinc=0;
        yinc=0;
        
        for jj=1:1:rns   %Affects X
            for ii=1:1:rns   %Affects Y
                Ppt=P1*phi(ii,1,jj)+P2*phi(ii,2,jj)+P3*phi(ii,3,jj)+P4*phi(ii,4,jj);
                
                ptpsx=xps+xinc*ElXad;
                ptpsy=yps+yinc*ElYad;
   
                %Plot Code%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if Ppt==0;                                                                    
                    cln=[0,0,0];
                    
                elseif Ppt > Pm_avg+Pm_std*4*pmvm                                                 
                    cln=[1,0,0]; %Red'
                                    
                elseif Ppt <= Pm_avg+pmvm*Pm_std*4  &&  Ppt > Pm_avg+pmvm*Pm_std*3
                    cln=[1,0.5,0]; %Orange'
                    
                elseif Ppt <= Pm_avg+pmvm*Pm_std*3  &&  Ppt > Pm_avg+pmvm*Pm_std*2            
                    cln=[1,1,0]; %Yellow'
                    
                elseif Ppt <= Pm_avg+pmvm*Pm_std*2  &&  Ppt > Pm_avg+pmvm*Pm_std*1              
                    cln=[0.5,1,0]; %Spring Green'
                    
                elseif Ppt <= Pm_avg+pmvm*Pm_std  &&  Ppt > Pm_avg-pmvm*Pm_std             
                    cln=[0,1,0]; %Green Middle of the road'
                
                elseif Ppt <= Pm_avg-pmvm*Pm_std*1  &&  Ppt >  Pm_avg-pmvm*Pm_std*2
                    cln=[0,1,0.5]; %Turquoise'
                    
                elseif Ppt <= Pm_avg-pmvm*Pm_std*2  &&  Ppt >  Pm_avg-pmvm*Pm_std*3          
                    cln=[0,1,1]; %Cyan'
                
                elseif Ppt < Pm_avg-pmvm*Pm_std*3  &&  Ppt > Pm_avg-pmvm*Pm_std*4          
                    cln=[0,0.5,1]; %Ocean'
                    
                elseif Ppt <= Pm_avg-Pm_std*4*pmvm              
                    cln=[0,0,1]; %Blue'
                end
                 
                plot(ptpsx,ptpsy,indicm,'Color',cln,'MarkerFaceColor',cln,'MarkerSize',1.5);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                xinc=xinc+1;
            end
            yinc=yinc+1;
            xinc=0;
        end
        if LPS==1
            tme=toc;
            estm=tme*cnms/60;
            fprintf('<> Render Time Estimate: %0.2fmin\n\n',estm);
        end
    end   
    
    hold off
    
    ttm=toc;
    ftm=ttm/60;
    fprintf('<> Render Complete <>\n');
    fprintf('<> Total Run Time: %0.2fmin\n\n',ftm);

end