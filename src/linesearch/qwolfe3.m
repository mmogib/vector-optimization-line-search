%%  向量优化的Wolfe线搜索
function [alphak,nf,ng]=qwolfe3(xk,dk,alphak,alphamax,nf,ng,d,r1,r2,r3)
rho=1e-4;
sigma=0.1;
delta=1.1;
alphakmin=1e-15;
rhoba=min(1.1*rho,0.75*rho+0.25*sigma);
sigmaba=max(0.9*sigma,0.25*rho+0.75*sigma);
s=0;
smax=100;
while (s<smax) 
    if r1*f1(xk+alphak*dk,d)<=r1*f1(xk,d)+alphak*rho*max([r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk]) && r2*f2(xk+alphak*dk,d)<=r2*f2(xk,d)+alphak*rho*max([r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk])  && r3*f3(xk+alphak*dk,d)<=r3*f3(xk,d)+alphak*rho*max([r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk]) && abs(max([r1*g1(xk+alphak*dk,d)'*dk,r2*g2(xk+alphak*dk,d)'*dk,r3*g3(xk+alphak*dk,d)'*dk]))<=-sigma*max([r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk])
        nf=nf+3;
        ng=ng+3;
        break;
    end
    if r1*f1(xk+alphamax*dk,d)<=r1*f1(xk,d)+alphamax*rho*max([ r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk]) && r1*g1(xk+alphamax*dk,d)'*dk<sigma*max([ r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk]) && r2*f2(xk+alphamax*dk,d)<=r2*f2(xk,d)+alphamax*rho*max([ r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk]) && r2*g2(xk+alphamax*dk,d)'*dk<sigma*max([ r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk]) && r3*f3(xk+alphamax*dk,d)<=r3*f3(xk,d)+alphamax*rho*max([ r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk]) && r3*g3(xk+alphamax*dk,d)'*dk<sigma*max([ r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk])
        nf=nf+3;
        ng=ng+3;
        alphak=alphamax;
        break
    end
    if r1*f1(xk+alphak*dk,d)>r1*f1(xk,d)+alphak*rho*max([ r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk]) ||  r1*g1(xk+alphak*dk,d)'*dk>-sigma*max([ r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk])
        nf=nf+1;
        ng=ng+1;
        alphamax=alphak;
        [alphak,nf,ng]=dwolfe1(xk,dk,alphamax,sigmaba,rhoba,nf,ng,d,r1,r2,r3);
    elseif r2*f2(xk+alphak*dk,d)>r2*f2(xk,d)+alphak*rho*max([ r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk]) ||  r2*g2(xk+alphak*dk,d)'*dk>-sigma*max([ r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk])
        nf=nf+1;
        ng=ng+1;
        alphamax=alphak;
        [alphak,nf,ng]=dwolfe2(xk,dk,alphamax,sigmaba,rhoba,nf,ng,d,r1,r2,r3);
    elseif r3*f3(xk+alphak*dk,d)>r3*f3(xk,d)+alphak*rho*max([ r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk]) || r3*g3(xk+alphak*dk,d)'*dk>-sigma*max([ r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk])
        nf=nf+1;
        ng=ng+1;
        alphamax=alphak;
        [alphak,nf,ng]=dwolfe3(xk,dk,alphamax,sigmaba,rhoba,nf,ng,d,r1,r2,r3);
    else
        alphak=(min(delta*alphak,alphamax)+alphamax)/2;
        
    end
    s=s+1;
    if alphak<=alphakmin
            alphak=alphakmin;
            break
    end
end