function [alphak,nf,ng]=qwolfe(xk,dk,alphak,alphamax,nf,ng,d,r1,r2)
% Quadratic Wolfe (m=2) using unified dispatcher (d = problemId)
rho=1e-4;
sigma=0.1;
delta=1.1;
alphakmin=1e-15;
rhoba=min(1.1*rho,0.75*rho+0.25*sigma);
sigmaba=max(0.9*sigma,0.25*rho+0.75*sigma);
s=0; smax=100;

[Ffun, Gfun] = problem_dispatcher(d, 2);

while (s<smax)
    [Fk, Gdk] = local_FG(xk, dk, Ffun, Gfun);
    [Fak, Gdak] = local_FG(xk + alphak*dk, dk, Ffun, Gfun);
    [Famax, Gdamax] = local_FG(xk + alphamax*dk, dk, Ffun, Gfun);

    phi0 = max([r1*Gdk(1), r2*Gdk(2)]);
    phi_a = max([r1*Gdak(1), r2*Gdak(2)]);
    phi_amax = max([r1*Gdamax(1), r2*Gdamax(2)]);
    armijo_rhs = alphak*rho*phi0;
    armijo_rhs_amax = alphamax*rho*phi0;

    if r1*Fak(1) <= r1*Fk(1) + armijo_rhs && r2*Fak(2) <= r2*Fk(2) + armijo_rhs && abs(phi_a) <= -sigma*phi0
        nf=nf+2; ng=ng+2; break;
    end
    if r1*Famax(1) <= r1*Fk(1) + armijo_rhs_amax && (r1*Gdamax(1) < sigma*phi0) && r2*Famax(2) <= r2*Fk(2) + armijo_rhs_amax && (r2*Gdamax(2) < sigma*phi0)
        nf=nf+2; ng=ng+2; alphak=alphamax; break
    end

    if (r1*Fak(1) > r1*Fk(1) + armijo_rhs) || (r1*Gdak(1) > -sigma*phi0)
        nf=nf+1; ng=ng+1; alphamax=alphak;
        [alphak,nf,ng]=dwolfe1_2obj(xk,dk,alphamax,sigmaba,rhoba,nf,ng,d,r1,r2);
    elseif (r2*Fak(2) > r2*Fk(2) + armijo_rhs) || (r2*Gdak(2) > -sigma*phi0)
        nf=nf+1; ng=ng+1; alphamax=alphak;
        [alphak,nf,ng]=dwolfe2_2obj(xk,dk,alphamax,sigmaba,rhoba,nf,ng,d,r1,r2);
    else
        alphak=(min(delta*alphak,alphamax)+alphamax)/2;
    end
    s=s+1;
    if alphak<=alphakmin, alphak=alphakmin; break; end
end

end

function [F, Gd] = local_FG(x, dk, Ffun, Gfun)
F = Ffun(x);
G = Gfun(x);
Gd = [G{1}'*dk, G{2}'*dk];
end

