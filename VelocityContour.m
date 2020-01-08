%Plotting Colors
function VelocityContour(v,XYCoords,type)
    [vnms,~]=size(v);
    
    pmvx=0.25;
    pmvy=0.015;
    pmvm=0.25;
    
    switch type
        case{'mxy'}
            vm=zeros(vnms,1);
            for LPS=1:1:vnms
                vm(LPS)=sqrt(v(LPS,1)^2+v(LPS,2)^2);
            end
            Vm_avg=mean(vm);
            Vm_std=std(vm);
            
            indicm='s';
            hold on
            for LPS=1:1:vnms         
                vmi=vm(LPS);
                
                xps=XYCoords(LPS,1);
                yps=XYCoords(LPS,2);

                %Color Choice for Point
                if vmi==0;                                                    cl=[0,0,0];
                elseif vmi > Vm_avg+Vm_std;                                   cl=[1,0,0];
                elseif vmi <= Vm_avg+Vm_std && vmi > Vm_avg+pmvm*Vm_std;      cl=[1,1,0];
                elseif vmi <= Vm_avg+pmvm*Vm_std && vmi > Vm_avg-pmvm*Vm_std; cl=[0,1,0];
                elseif vmi <= Vm_avg-pmvm*Vm_std && vmi >= Vm_avg-Vm_std;     cl=[0,1,1];
                elseif vmi < Vm_avg-Vm_std;                                   cl=[0,0,1];
                end
                                                
                plot(xps,yps,indicm,'Color',cl,'MarkerFaceColor',cl,'MarkerSize',15);
            end
            hold off
            
            
        
        case {'x','xa'}
            Vx_avg=mean(v(:,1));
            Vx_std=std(v(:,1));
            
            hold on
            for LPS=1:1:vnms
                vx=v(LPS,1);
                
                xps=XYCoords(LPS,1);
                yps=XYCoords(LPS,2);

                %Color Choice for Point
                if vx==0;                                                   cl=[0,0,0];
                elseif vx > Vx_avg+Vx_std;                                  cl=[1,0,0];
                elseif vx <= Vx_avg+Vx_std && vx > Vx_avg+pmvx*Vx_std;      cl=[1,1,0];
                elseif vx <= Vx_avg+pmvx*Vx_std && vx > Vx_avg-pmvx*Vx_std; cl=[0,1,0];
                elseif vx <= Vx_avg-pmvx*Vx_std && vx >= Vx_avg-Vx_std;     cl=[0,1,1];
                elseif vx < Vx_avg-Vx_std;                                  cl=[0,0,1];
                end
                
                if 1==strcmp(type,'xa')
                    if vx==0; indicx='s';
                    elseif vx<0; indicx='<';
                    elseif vx>0; indicx='>';
                    end
                else indicx='s';
                end
                
                plot(xps,yps,indicx,'Color',cl,'MarkerFaceColor',cl,'MarkerSize',15);
            end
            hold off
    
        case {'y','ya'}
            Vy_avg=mean(v(:,2));
            Vy_std=std(v(:,2));

            
            hold on
            for LPS=1:1:vnms
                vy=v(LPS,2);

                xps=XYCoords(LPS,1);
                yps=XYCoords(LPS,2);

                %Color Choice for Point
                if vy==0;                                                     cl=[0,0,0];
                elseif vy > Vy_avg+Vy_std;                                    cl=[1,0,0];
                elseif vy <= Vy_avg+Vy_std && vy > Vy_avg+pmvy*Vy_std;        cl=[1,1,0];
                elseif vy <= Vy_avg+pmvy*Vy_std && vy > Vy_avg-pmvy*Vy_std;   cl=[0,1,0];
                elseif vy <= Vy_avg-pmvy*Vy_std && vy >= Vy_avg-Vy_std;       cl=[0,1,1];
                elseif vy < Vy_avg-Vy_std;                                    cl=[0,0,1];
                end
                
                if 1==strcmp(type,'ya')
                    if vy==0; indicy='s';
                    elseif vy<0; indicy='v';
                    elseif vy>0; indicy='^';
                    end               
                else indicy='s';
                end
                
                plot(xps,yps,indicy,'Color',cl,'MarkerFaceColor',cl,'MarkerSize',15);
            end
            hold off
            
            
        case 'xya'
            Vx_avg=mean(v(:,1));
            Vx_std=std(v(:,1));
            Vy_avg=mean(v(:,2));
            Vy_std=std(v(:,2));


            hold on
            for LPS=1:1:vnms
                vx=v(LPS,1);
                vy=v(LPS,2);

                xpsx=XYCoords(LPS,1);
                ypsx=XYCoords(LPS,2);

                xpsy=XYCoords(LPS,1);
                ypsy=XYCoords(LPS,2);       


                %Color Choice for Point
                if vx==0;                                                    clx=[0,0,0];
                elseif vx > Vx_avg+Vx_std;                                   clx=[1,0,0];
                elseif vx <= Vx_avg+Vx_std && vx > Vx_avg+pmvx*Vx_std;       clx=[1,1,0];
                elseif vx <= Vx_avg+pmvx*Vx_std && vx > Vx_avg-pmvx*Vx_std;  clx=[0,1,0];
                elseif vx <= Vx_avg-pmvx*Vx_std && vx >= Vx_avg-Vx_std;      clx=[0,1,1];
                elseif vx < Vx_avg-Vx_std;                                   clx=[0,0,1];
                end
                if vx==0; indicx='s';
                elseif vx<0; indicx='<';
                elseif vx>0; indicx='>';
                end

                if vy==0;                                                    cly=[0,0,0];
                elseif vy > Vy_avg+Vy_std;                                   cly=[0.75,0,0];
                elseif vy <= Vy_avg+Vy_std && vy > Vy_avg+pmvy*Vy_std;       cly=[0.75,0.75,0];
                elseif vy <= Vy_avg+pmvy*Vy_std && vy > Vy_avg-pmvy*Vy_std;  cly=[0,0.75,0];
                elseif vy <= Vy_avg-pmvy*Vy_std && vy >= Vy_avg-Vy_std;      cly=[0,0.75,0.75];
                elseif vy < Vy_avg-Vy_std;                                   cly=[0,0,0.75];
                end
                if vy==0; indicy='s';
                elseif vy<0; indicy='v';
                elseif vy>0; indicy='^';
                end

                plot(xpsx,ypsx,indicx,'Color',clx,'MarkerFaceColor',clx,'MarkerSize',20);
                plot(xpsy,ypsy,indicy,'Color',cly,'MarkerFaceColor',cly);
            end
            hold off
    end

end




%     
% end