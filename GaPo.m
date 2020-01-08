%Two Point Gaussian Integration Points
%4-Noded Rectangular Element
function [gp,w,ngp] = GaPo
    ngp=4;
    w=[1;1;1;1];
    gp=[-sqrt(1/3),-sqrt(1/3);...
        -sqrt(1/3),sqrt(1/3);...
        sqrt(1/3),-sqrt(1/3);...
        sqrt(1/3),sqrt(1/3)];
end