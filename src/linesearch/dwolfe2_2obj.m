function [alphak,nf,ng]=dwolfe2_2obj(xk,dk,alphamax,sigmaba,rhoba,nf,ng,d,r1,r2)
% Two-objective strong Wolfe along objective 2
alpha0=0; alpha1=alphamax/2; i=1; imax=40;
while i<imax
    if r2*f2(xk+alpha1*dk,d)>r2*f2(xk,d)+alpha1*rhoba*max([r1*g1(xk,d)'*dk, r2*g2(xk,d)'*dk]) || (r2*f2(xk+alpha1*dk,d)>=r2*f2(xk+alpha0*dk,d) && i>1)
        nf=nf+2;
        [alphak,nf,ng]=zoom21_2obj(alpha0,alpha1,dk,xk,sigmaba,rhoba,nf,ng,d,r1,r2);
        break;
    end
    if abs(r2*g2(xk+alpha1*dk,d)'*dk)<=-sigmaba*max([r1*g1(xk,d)'*dk, r2*g2(xk,d)'*dk])
        ng=ng+1; alphak=alpha1; break
    end
    if r2*g2(xk+alpha1*dk,d)'*dk>=0
        ng=ng+1;
        [alphak,nf,ng]=zoom22_2obj(alpha1,alpha0,dk,xk,sigmaba,rhoba,nf,ng,d,r1,r2);
        break;
    end
    alpha1=(alpha1+alphamax)/2; i=i+1;
end

% Fallback in case no break assigned alphak
if ~exist('alphak','var')
    alphak = alpha1;
end
