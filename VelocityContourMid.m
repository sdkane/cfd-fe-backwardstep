function VelocityContourMid(v,XYCoords,ConM,MshXY,NELXY)
    fprintf('<> Rendering Velocity Contour <>\n');
    [vnms,~]=size(v);
    [cnms,~]=size(ConM);
        
    pmvm=0.15;%0.25; %0.15;
    
    vm=zeros(vnms,1);
    for LPS=1:1:vnms
        vm(LPS)=sqrt(v(LPS,1)^2+v(LPS,2)^2);
    end
    
    Vm_avg=mean(vm);
    Vm_std=std(vm);
    
    %Setting Up Evaluation Points Within an Element for Interpolation
    
    stp=0.05;
    rns=2/stp+1;
    
    fprintf('<> Points Per Element %0.0f\n',ceil(rns*rns));
    fprintf('<> Total Points %0.0f\n',ceil(rns*rns)*vnms);
        
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
        vm1=vm(ConM(LPS,1));    %Nodal Velocities for the Element
        vm2=vm(ConM(LPS,2));
        vm3=vm(ConM(LPS,3));
        vm4=vm(ConM(LPS,4));
        
        xps=XYCoords(ConM(LPS),1); %Local Node 1 X-Position
        yps=XYCoords(ConM(LPS),2); %Local Node 1 Y-Position
        
        xinc=0;
        yinc=0;
        
        for jj=1:1:rns   %Affects X
            for ii=1:1:rns   %Affects Y
                vpt=vm1*phi(ii,1,jj)+vm2*phi(ii,2,jj)+vm3*phi(ii,3,jj)+vm4*phi(ii,4,jj);
                
                ptpsx=xps+xinc*ElXad;
                ptpsy=yps+yinc*ElYad;
   
                %Plot Code%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if vpt==0;                                                                    
                    cln=[0,0,0];
                    
                elseif vpt > Vm_avg+Vm_std*4*pmvm                                                 
                    cln=[1,0,0]; %Red'
                                    
                elseif vpt <= Vm_avg+pmvm*Vm_std*4  &&  vpt > Vm_avg+pmvm*Vm_std*3
                    cln=[1,0.5,0]; %Orange'
                    
                elseif vpt <= Vm_avg+pmvm*Vm_std*3  &&  vpt > Vm_avg+pmvm*Vm_std*2            
                    cln=[1,1,0]; %Yellow'
                    
                elseif vpt <= Vm_avg+pmvm*Vm_std*2  &&  vpt > Vm_avg+pmvm*Vm_std*1              
                    cln=[0.5,1,0]; %Spring Green'
                                         
                elseif vpt <= Vm_avg+pmvm*Vm_std  &&  vpt > Vm_avg-pmvm*Vm_std             
                    cln=[0,1,0]; %Green Middle of the road'
                
                elseif vpt <= Vm_avg-pmvm*Vm_std*1  &&  vpt >  Vm_avg-pmvm*Vm_std*2
                    cln=[0,1,0.5]; %Turquoise'
                    
                elseif vpt <= Vm_avg-pmvm*Vm_std*2  &&  vpt >  Vm_avg-pmvm*Vm_std*3          
                    cln=[0,1,1]; %Cyan'
                
                elseif vpt < Vm_avg-pmvm*Vm_std*3  &&  vpt > Vm_avg-pmvm*Vm_std*4          
                    cln=[0,0.5,1]; %Ocean'
                    
                elseif vpt <= Vm_avg-Vm_std*4*pmvm              
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