
function [alphak,nf,ng]=qwolfe(xk,dk,alphak,alphamax,nf,ng,r,r1,m,n)
rho=1e-4;
sigma=0.1;
delta=1.1;
alphakmin=1e-15;
rhoba=min(1.1*rho,0.75*rho+0.25*sigma);
sigmaba=max(0.9*sigma,0.25*rho+0.75*sigma);
s=0;
smax=100;
while (s<smax)   
    F1=r'.*f(xk);
    G1=g(xk).*r1;
    F2=r'.*f(xk+alphak*dk);
    nf=nf+1;
    G2=g(xk+alphak*dk).*r1;
    ng=ng+1;
    z1=0;
    for c=1:m
    if  F2(c)<=F1(c)+(alphak*rho*max(G1*dk)) && abs(max(G2*dk))<=-sigma*max(G1*dk)
        z1=z1+1;
    end
    end
    if z1==m
        break
    end
    F3=r'.*f(xk+alphamax*dk);
    G3=g(xk+alphamax*dk).*r1;
    nf=nf+1;
    ng=ng+1;
    z2=0;
    for c=1:m
        g3dk=G3*dk;
    if  F3(c)<=F1(c)+(alphamax*rho*max(G1*dk)) && g3dk(c)<(sigma*max(G1*dk)) 
        z2=z2+1;
    end
    end
    if z2==m
       alphak=alphamax;
        break
    end
    for i=1:m+1
        if i<=m
        if F2(i)>F1(i)+alphak*rho*max(G1*dk) || G2(i,1:n)*dk>-sigma*max(G1*dk)
            alphamax=alphak;
            [alphak,nf,ng]=dwolfe(xk,dk,alphamax,sigmaba,rhoba,nf,ng,i,r,r1,n);
            break
        end
        else
            alphak=(min(delta*alphak,alphamax)+alphamax)/2;
        end
    end
    s=s+1;
    if alphak<=alphakmin
            alphak=alphakmin;
            break
    end
end