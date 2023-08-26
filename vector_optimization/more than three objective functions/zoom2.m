
function [alphak,nf,ng]=zoom2(alpha1,alpha0,xk,dk,sigmaba,rhoba,nf,ng,i,r,r1,n)
s=0;smax=20;
while (s<smax)
    alphaj=(alpha0+alpha1)/2;
       F6=r'.*f(xk+alphaj*dk);
       F5=r'.*f(xk+alpha1*dk);
       G5=g(xk+alphaj*dk).*r1;
       nf=nf+2;
       ng=ng+1;
       F1=r'.*f(xk);
       G1=g(xk).*r1;
    if F6(i)>F1(i)+alphaj*rhoba*max(G1*dk) || F6(i)>=F5(i)
        
        alpha0=alphaj;
    else
        if abs(G5(i,1:n)*dk)<=sigmaba*abs(max(G1*dk))
            
            alphak=alphaj;
            break
        end
        if (G5(i,1:n)*dk)*(alpha0-alpha1)>=0
         
         alpha0=alpha1;   
        end
        alpha1=alphaj;
    end
    s=s+1;
    if s==20
     alphak=alphaj;
    end
end
        