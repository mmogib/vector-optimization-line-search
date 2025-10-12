clear,clc
%% Read data
h=14;
m=3;
Loop=100;
Rloopk=zeros(Loop,h);
Rloopnf=zeros(Loop,h);
Rloopng=zeros(Loop,h);
Rloopnv=zeros(Loop,h);
Rloopt=zeros(Loop,h);
Rloopchu=zeros(Loop,h*m);
Rloophv=zeros(h,1);
for d=1:12
    for iLoop=1:Loop
        tic;
        %%  Initialization
        nv=1;
        k=1;
        nf=1;
        ng=1;
        alphamax=10^10;
       if d==1
            S1 = load('IKK1.mat');
            n=2;
            % xk =-50+(50-(-50))*rand(n,1);
        elseif d==2
            S1 = load('T8157.mat');
            n=15;
           % xk = 0.1 + ( 10 - (0.1 ))*rand(n,1);
        elseif d==3
            S1 = load('T830.mat');
            n=30;
        %    xk = 0.1 + ( 10 - (0.1 ))*rand(n,1);
        elseif d==4
            S1 = load('T850.mat');
            n=50;
          %  xk = 0.1 + ( 10 - (0.1 ))*rand(n,1);
        elseif d==5
            S1 = load('MOP5.mat');
            n=2;
        elseif d==6
            S1 = load('MOP77.mat');
            n=2;
            %xk = -400+(400-(-400))*rand(n,1);
        elseif d==7
            S1 = load('FDS.mat');
            n=10;
            % xk = -2 + ( 2 - ( -2 ))*rand(n,1);
        elseif d==8
            S1 = load('FDS2000.mat');
            n=2000;
           %  xk = -2 + ( 2 - ( -2 ))*rand(n,1);
        elseif d==9
            S1 = load('FDS1007.mat');
            n=100;
            % xk = -2 + ( 2 - ( -2 ))*rand(n,1);
        elseif d==10
            S1 = load('SLCDT27.mat');
            n=10;
          %  xk =-100+(100-(-100))*rand(n,1);
        elseif d==11
            S1 = load('TRI.mat');
            n=3;
           %  xk =-1+(1-(-1))*rand(n,1);
        elseif d==12
            S1 = load('AP11.mat');
            n=2;
        end
        BP1 = struct2cell(S1);
        Mymat1 = cell2mat(BP1);
        x0=Mymat1(1:n,iLoop);
        xk=Mymat1(1:n,iLoop);
       % x0=xk;
        gd1=g1(x0,d);
        gd2=g2(x0,d);
        gd3=g3(x0,d);
        r1=1/max(1,norm(gd1,inf));
        r2=1/max(1,norm(gd2,inf));
        r3=1/max(1,norm(gd3,inf));
        F=[r1*f1(xk,d);r2*f2(xk,d);r3*f3(xk,d)];
        nf=nf+3;
        %% Solve subproblem
        H=zeros(n+1,n+1);
        H(2:n+1,2:n+1)=eye(n);
        ff=zeros(n+1,1);
        ff(1,1)=1;
        A=[-1 r1*g1(xk,d)' ;-1 r2*g2(xk,d)';-1 r3*g3(xk,d)'];
        ng=ng+3;
        b=zeros(m,1);
        xx=ones(n+1,1);
        [dd,sitak]= quadprog(H,ff,A,b,[],[],[],[],xx);
        nv=nv+1;
        vk=dd(2:n+1);
        fxkvk=dd(1);
        %% Set stopping precise
        epsilon = 2.22e-16;
        %% Compute direction
        dk=vk;
        %% Compute initial step (k=1)
        alphak=1/norm(dk);
        alphak=max(alphak,1);
        alphak=min(alphak,alphamax);
        %% Inner loop
        while 1
            if sitak>=-5*sqrt(epsilon)
                break
            else
                % Compute the stepsize satisfying the strong Wolfe conditions
                [alphak,nf,ng]=qwolfe3(xk,dk,alphak,alphamax,nf,ng,d,r1,r2,r3);
                fxkvk=max([r1*g1(xk,d)'*vk,r2*g2(xk,d)'*vk,r3*g3(xk,d)'*vk]);
                x1=xk+alphak*dk;
                fxkdk=max([r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk,r3*g3(xk,d)'*dk]);%tao3
                F1=[r1*f1(x1,d);r2*f2(x1,d);r3*f3(x1,d)];
                nf=nf+3;
        H=zeros(n+1,n+1);
        H(2:n+1,2:n+1)=eye(n);
        ff=zeros(n+1,1);
        ff(1,1)=1;
        A=[-1 r1*g1(x1,d)' ;-1 r2*g2(x1,d)';-1 r3*g3(x1,d)'];
        ng=ng+3;
        b=zeros(m,1);
        xx=ones(n+1,1);
        [d1,sitak1]= quadprog(H,ff,A,b,[],[],[],[],xx);
                nv=nv+1;
                vk1=d1(2:n+1);
                fxk1vk1=d1(1);
                fxkvk1=max([r1*g1(xk,d)'*vk1,r2*g2(xk,d)'*vk1,r3*g3(xk,d)'*vk1]);
                ng=ng+3;
                betak=max(0,(-fxk1vk1+fxkvk1)/(-fxkvk));
                dk1=vk1+betak*dk;
                fxk1dk1=max([r1*g1(x1,d)'*dk1,r2*g2(x1,d)'*dk1,r3*g3(x1,d)'*dk1]);
            end
            if  k>=5000
                k=nan;
                nf=nan;
                ng=nan;
                nv=nan;
                break
            end
            k=k+1;
            dk=dk1;
            vk=vk1;
            xk=x1;
            sitak=sitak1;
            % Compute initial step (k>1)
          alphak=alphak*fxkdk/fxk1dk1;
          alphak=max(alphak,0.02);
          alphak=min(alphak,100);
        end
        t=toc;
        FF1=[f1(xk,d),f2(xk,d),f3(xk,d)];
        Rloopk(iLoop,d)=k;
        Rloopnf(iLoop,d)=nf;
        Rloopng(iLoop,d)=ng;
        Rloopnv(iLoop,d)=nv;
        Rloopt(iLoop,d)=t;
    Rloopchu(iLoop,d*m-2:d*m)=FF1;
    end
    
end
