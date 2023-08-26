
function [alphak,nf,ng]=zoom21(alpha0,alpha1,dk,xk,sigmaba,rhoba,epsiki,nf,ng,i,r,r1,n)
s=0;smax=20;
while (s<smax)
    alphaj=(alpha0+alpha1)/2;
       F6=r'.*f(xk+alphaj*dk);
       F5=r'.*f(xk+alpha0*dk);
       G5=g(xk+alphaj*dk).*r1;
       nf=nf+2;
       ng=ng+1;
       F1=r'.*f(xk);
       G1=g(xk).*r1;
    if F6(i)>F1(i)+alphaj*rhoba*max(G1*dk) || F6(i)>=F5(i)
       
        alpha1=alphaj;
    else
        if G5(i,1:n)*dk>=sigmaba*max(G1*dk)&& G5(i,1:n)*dk<=epsiki
           
            alphak=alphaj;
            break
        end
        if (G5(i,1:n)*dk)*(alpha1-alpha0)>=0
         
         alpha1=alpha0;   
        end
        alpha0=alphaj;
    end
    s=s+1;
    if s==20
    alphak=alphaj;
    end
end
        