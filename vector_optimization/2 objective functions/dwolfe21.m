
function [alphak,nf,ng]=dwolfe21(xk,dk,alphamax,epsiki,sigmaba,rhoba,nf,ng,d,r1,r2)

alpha0=0;alpha1=alphamax/2;
i=1;imax=40;
while i<imax 
    if r1*f1(xk+alpha1*dk,d)>r1*f1(xk,d)+alpha1*rhoba*max([r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk]) || (r1*f1(xk+alpha1*dk,d)>=r1*f1(xk+alpha0*dk,d) &&  i>1)
       nf=nf+2;
        [alphak,nf,ng]=zoom211(alpha0,alpha1,epsiki,xk,dk,sigmaba,rhoba,nf,ng,d,r1,r2);
        break;
    end
    if r1*g1(xk+alpha1*dk,d)'*dk>=sigmaba*max([r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk])&& r1*g1(xk+alpha1*dk,d)'*dk<=epsiki
        ng=ng+1;
        alphak=alpha1;
        break
    end
    if r1*g1(xk+alpha1*dk,d)'*dk>=0
        ng=ng+1;
        [alphak,nf,ng]=zoom212(alpha1,alpha0,epsiki,xk,dk,sigmaba,rhoba,nf,ng,d,r1,r2);
        break;
    end
    alpha2=(alpha1+alphamax)/2;
    alpha1=alpha2;
    i=i+1;     
end
      