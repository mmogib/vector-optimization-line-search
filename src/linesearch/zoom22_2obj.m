function [alphak,nf,ng]=zoom22_2obj(alpha0,alpha1,dk,xk,sigmaba,rhoba,nf,ng,d,r1,r2)
s=0; smax=20;
while (s<smax)
    alphaj=(alpha0+alpha1)/2;
    if r2*f2(xk+alphaj*dk,d)>r2*f2(xk,d)+alphaj*rhoba*max([r1*g1(xk,d)'*dk, r2*g2(xk,d)'*dk]) || r2*f2(xk+alphaj*dk,d)>=r2*f2(xk+alpha0*dk,d)
        nf=nf+2; alpha1=alphaj;
    else
        if abs(r2*g2(xk+alphaj*dk,d)'*dk)<=sigmaba*abs(max([r1*g1(xk,d)'*dk, r2*g2(xk,d)'*dk]))
            ng=ng+1; alphak=alphaj; break;
        end
        if (r2*g2(xk+alphaj*dk,d)'*dk)*(alpha1-alpha0)>=0
            ng=ng+1; alpha1=alpha0;
        end
        alpha0=alphaj;
    end
    s=s+1; if s==20, alphak=alphaj; end
end

% Fallback
if ~exist('alphak','var')
    alphak = (alpha0+alpha1)/2;
end
