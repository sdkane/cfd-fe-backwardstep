%Computes the case at the gauss point provided
function [Ret] = Cmpt(fct,gpp,x)
    z1=gpp(1); z2=gpp(2);
    switch fct
        case 'Phi'                                                          %Shape Function
            Ret=[0.25*(z1*z2-z2-z1+1);...
                  0.25*(z1-z2-z1*z2+1);...
                  0.25*(z1+z2+z1*z2+1);...
                  0.25*(z2-z1-z1*z2+1)];
            
        case 'dPhi'                                                         %Derivative of Shape Function
            Ret=0.25*[z2-1,  z1-1;...
                       1-z2,-z1-1;...
                       z2+1, z1+1;...
                      -z2-1, 1-z1];              
                  
        case 'Jac'                                                          %Jacobian
            A=0.25*[z2-1,  z1-1;...
                     1-z2,-z1-1;...
                     z2+1, z1+1;...
                    -z2-1, 1-z1];
                         
            Ret=A'*x;
                        
        otherwise
            fprintf('Not a valid function to solve in Cmpt\n');
    end
end

%CALLED BY: GlobalConstants
%CALLS: -