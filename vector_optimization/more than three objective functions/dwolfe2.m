
function [alphak,nf,ng]=dwolfe2(xk,dk,alphamax,epsiki,sigmaba,rhoba,nf,ng,i,r,r1,n)
alpha0=0;alpha1=alphamax/2;s=1;imax=40;
while s<imax 
    F4=r'.*f(xk+alpha1*dk);
    F5=r'.*f(xk+alpha0*dk);
    G4=g(xk+alpha1*dk).*r1;
    nf=nf+2;
    ng=ng+1;
    F1=r'.*f(xk);
    G1=g(xk).*r1;
    if F4(i)>F1(i)+alpha1*rhoba*max(G1*dk) || (F4(i)>=F5(i) && s>1)
       [alphak,nf,ng]=zoom21(alpha0,alpha1,xk,dk,sigmaba,rhoba,epsiki,nf,ng,i,r,r1,n);
       break
    end
    if G4(i,1:n)*dk>=sigmaba*max(G1*dk) && G4(i,1:n)*dk<=epsiki
        alphak=alpha1;
        break
    end
    if G4(i,1:n)*dk>=0
       [alphak,nf,ng]=zoom22(alpha1,alpha0,xk,dk,sigmaba,rhoba,epsiki,nf,ng,i,r,r1,n);
       break
    end
    alpha2=(alpha1+alphamax)/2;
    alpha1=alpha2;
    s=s+1;   
end
      