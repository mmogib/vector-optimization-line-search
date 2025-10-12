 clear,clc
% Mymat11: It is the number of iterations obtained by the HZ method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems. 
% Mymat12: It is the number of function evaluations obtained by the HZ method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems. 
% Mymat13: It is the number of gradient evaluations obtained by the HZ method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems. 
% Mymat14: It is the number of vector steepest descent evaluations obtained by the HZ method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems. 
% Mymat15: It is the CPU time obtained by the HZ method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems.
 
% Mymat21: It is the number of iterations obtained by the PRP+ method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems.
% Mymat22: It is the number of function evaluations obtained by the PRP+ method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems. 
% Mymat23: It is the number of gradient evaluations obtained by the PRP+ method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems.
% Mymat24: It is the number of vector steepest descent evaluations obtained by the PRP+ method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems. 
% Mymat25: It is the CPU time obtained by the PRP+ method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems.

% Mymat31: It is the number of iterations obtained by the SD method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems.
% Mymat32: It is the number of function evaluations obtained by the SD method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems.
% Mymat33: It is the number of gradient evaluations obtained by the SD method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems.
% Mymat34: It is the number of vector steepest descent evaluations obtained by the SD method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems. 
% Mymat35: It is the CPU time obtained by the SD method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems.
 
 
% Mymat41: It is the number of iterations obtained by the HZN method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems.
% Mymat42: It is the number of function evaluations obtained by the HZN method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems.
% Mymat43: It is the number of gradient evaluations obtained by the HZN method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems.
% Mymat44: It is the number of vector steepest descent evaluations obtained by the HZN method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems. 
% Mymat45: It is the CPU time obtained by the HZN method for all
% problems. a 100 x 56 matrix, where 100 represents 100 different initial points 
% for a problem and 56 represents 56 problems.
h=56;hh=100;hhh=56*hh;
Rloop=zeros(h,24);
%% compute the median value
for t=1:h
    p11=Mymat11(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,1)=ss;
end
for t=1:h
    p11=Mymat12(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,2)=ss;
end
for t=1:h
    p11=Mymat13(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,3)=ss;
end
for t=1:h
    p11=Mymat14(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,4)=ss;
end
for t=1:h
    p11=Mymat15(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,5)=ss;
end
for t=1:h
    p11=Mymat11(:,t);
    no=0;
    for i=1:100
        if isnan(p11(i))
            no=no+1;
        end
    end
    ss=(100-no)/100;
    Rloop(t,6)=ss;
end
for t=1:h
    p11=Mymat21(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,7)=ss;
end
for t=1:h
    p11=Mymat22(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,8)=ss;
end
for t=1:h
    p11=Mymat23(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,9)=ss;
end
for t=1:h
    p11=Mymat24(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,10)=ss;
end
for t=1:h
    p11=Mymat25(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,11)=ss;
end
for t=1:h
    p11=Mymat21(:,t);
    no=0;
    for i=1:100
        if isnan(p11(i))
            no=no+1;
        end
    end
    ss=(100-no)/100;
    Rloop(t,12)=ss;
end
for t=1:h
    p11=Mymat31(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,13)=ss;
end
for t=1:h
    p11=Mymat32(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,14)=ss;
end
for t=1:h
    p11=Mymat33(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,15)=ss;
end
for t=1:h
    p11=Mymat34(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,16)=ss;
end
for t=1:h
    p11=Mymat35(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,17)=ss;
end
for t=1:h
    p11=Mymat31(:,t);
    no=0;
    for i=1:100
        if isnan(p11(i))
            no=no+1;
        end
    end
    ss=(100-no)/100;
    Rloop(t,18)=ss;
end
for t=1:h
    p11=Mymat41(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,19)=ss;
end
for t=1:h
    p11=Mymat42(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,20)=ss;
end
for t=1:h
    p11=Mymat43(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,21)=ss;
end
for t=1:h
    p11=Mymat44(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,22)=ss;
end
for t=1:h
    p11=Mymat45(:,t);
    p111=sort(p11);
    s11=p111(49)+p111(50);
    ss=s11/2;
    Rloop(t,23)=ss;
end
for t=1:h
    p11=Mymat41(:,t);
    no=0;
    for i=1:100
        if isnan(p11(i))
            no=no+1;
        end
    end
    ss=(100-no)/100;
    Rloop(t,24)=ss;
end
for dd=1:5
   if  dd==1
        k1=[];k2=[];k3=[];k4=[];
        for q1=1:h
            k1=[k1;Mymat11(:,q1)];
            k2=[k2;Mymat21(:,q1)];
            k3=[k3;Mymat31(:,q1)];
            k4=[k4;Mymat41(:,q1)];
        end
        R1=zeros(hhh,1);
        R2=zeros(hhh,1);
        R3=zeros(hhh,1);
        R4=zeros(hhh,1);
        for q=1:hhh
            kNCG=k1(q);
            kSD=k2(q);
            kPRP1=k3(q);
            kHS1=k4(q);
            R1(q)=kNCG;
            R2(q)=kSD;
            R3(q)=kPRP1;
            R4(q)=kHS1;
        end
        R1(find(isnan(R1)))=5000;
        R2(find(isnan(R2)))=5000;
        R3(find(isnan(R3)))=5000;
        R4(find(isnan(R4)))=5000;
        nfsum=[R1 R2 R3 R4];
        iter=nfsum;
        [m,n]=size(iter);
        ndd=m;
        for i=1:ndd
            mi=inf;
            for j=1:n
                if iter(i,j)~=0 && iter(i,j)<mi
                    mi=iter(i,j);
                end
            end
            for j=1:n
                iter(i,j)=iter(i,j)/mi;
            end
        end
        iterinum=[];
        for i=1:n
            a=unique(iter(:,i));
            na=length(a);
            iterinum=[iterinum,na];
        end
        tmax=max(iterinum);
        tx=ones(n,tmax);
        ty=ones(n,tmax);
        for i=1:n
            a=unique(iter(:,i));
            na=length(a);
            e=zeros(1,na-1);
            for k=2:na
                for j=1:ndd
                    if iter(j,i) <= a(k)
                        e(k-1)=e(k-1)+1;
                    end
                end
            end
            e=e./ndd;
            [me,ne]=size(e);
            tx(i,:)=max(a(2:na))*tx(i,:);
            ty(i,:)=max(e)*ty(i,:);
            tx(i,1:na-1)=a(2:na);
            ty(i,1:ne)=e;
        end
       subplot(2,3,1) ;
       plot(tx(1,:),ty(1,:),'-.','Color',[0.49,0.18,0.56],'linewidth',2)
        hold on
        plot(tx(2,:),ty(2,:),'-.','Color',[0.93,0.69,0.13],'linewidth',2)
        hold on
        plot(tx(3,:),ty(3,:),'-.','Color',[0,0.4470,0.7410],'linewidth',2)
        hold on
        plot(tx(4,:),ty(4,:),'-*','MarkerIndices',1,'Color',[0.85,0.33,0.10],'linewidth',2)
        hold on
        axis([1 5 0 1])
        xlabel('\tau')
        ylabel('\rho(\tau)')
        title('(I) Iterations','fontname','Times New Roman','Color','k','FontSize',13)
        legend('HZ','PRP+','SD','HZN')
   elseif dd==2
        k1=[];k2=[];k3=[];k4=[];
        for q1=1:h
            k1=[k1;Mymat12(:,q1)];
            k2=[k2;Mymat22(:,q1)];
            k3=[k3;Mymat32(:,q1)];
            k4=[k4;Mymat42(:,q1)];
        end
        R1=zeros(hhh,1);
        R2=zeros(hhh,1);
        R3=zeros(hhh,1);
        R4=zeros(hhh,1);
        for q=1:hhh
            kNCG=k1(q);
            kSD=k2(q);
            kPRP1=k3(q);
            kHS1=k4(q);           
            R1(q)=kNCG;
            R2(q)=kSD;
            R3(q)=kPRP1;
            R4(q)=kHS1;
        end
        R1(find(isnan(R1)))=5000;
        R2(find(isnan(R2)))=5000;
        R3(find(isnan(R3)))=5000;
        R4(find(isnan(R4)))=5000;
        nfsum=[R1 R2 R3 R4];
        iter=nfsum;
        [m,n]=size(iter);
        ndd=m;
        for i=1:ndd
            mi=inf;
            for j=1:n
                if iter(i,j)~=0 && iter(i,j)<mi
                    mi=iter(i,j);
                end
            end
            for j=1:n
                iter(i,j)=iter(i,j)/mi;
            end
        end
        iterinum=[];
        for i=1:n
            a=unique(iter(:,i));
            na=length(a);
            iterinum=[iterinum,na];
        end
        tmax=max(iterinum);
        tx=ones(n,tmax);
        ty=ones(n,tmax);
        for i=1:n
            a=unique(iter(:,i));
            na=length(a);
            e=zeros(1,na-1);
            for k=2:na
                for j=1:ndd
                    if iter(j,i) <= a(k)
                        e(k-1)=e(k-1)+1;
                    end
                end
            end
            e=e./ndd;
            [me,ne]=size(e);
            tx(i,:)=max(a(2:na))*tx(i,:);
            ty(i,:)=max(e)*ty(i,:);
            tx(i,1:na-1)=a(2:na);
            ty(i,1:ne)=e;
        end
        subplot(2,3,2)
        plot(tx(1,:),ty(1,:),'-.','Color',[0.49,0.18,0.56],'linewidth',2)
        hold on
        plot(tx(2,:),ty(2,:),'-.','Color',[0.93,0.69,0.13],'linewidth',2)
        hold on
        plot(tx(3,:),ty(3,:),'-.','Color',[0,0.4470,0.7410],'linewidth',2)
        hold on
        plot(tx(4,:),ty(4,:),'-','Color',[0.85,0.33,0.10],'linewidth',2)
        hold on
        axis([1 20 0 1])
        xlabel('\tau')
        ylabel('\rho(\tau)')
       title('(II) Function evaluations','fontname','Times New Roman','Color','k','FontSize',13) 
        legend('HZ','PRP+','SD','HZN')
    elseif dd==3
        k1=[];k2=[];k3=[];k4=[];
        for q1=1:h
            k1=[k1;Mymat13(:,q1)];
            k2=[k2;Mymat23(:,q1)];
            k3=[k3;Mymat33(:,q1)];
            k4=[k4;Mymat43(:,q1)];
        end
        R1=zeros(hhh,1);
        R2=zeros(hhh,1);
        R3=zeros(hhh,1);
        R4=zeros(hhh,1);
        for q=1:hhh
            kNCG=k1(q);
            kSD=k2(q);
            kPRP1=k3(q);
            kHS1=k4(q);
            R1(q)=kNCG;
            R2(q)=kSD;
            R3(q)=kPRP1;
            R4(q)=kHS1;
        end
        R1(find(isnan(R1)))=5000;
        R2(find(isnan(R2)))=5000;
        R3(find(isnan(R3)))=5000;
        R4(find(isnan(R4)))=5000;
        ngsum=[R1 R2 R3 R4];
        iter=ngsum;
        [m,n]=size(iter);
        ndd=m;
        for i=1:ndd
            mi=inf;
            for j=1:n
                if iter(i,j)~=0 && iter(i,j)<mi
                    mi=iter(i,j);
                end
            end
            for j=1:n
                iter(i,j)=iter(i,j)/mi;
            end
        end
        iterinum=[];
        for i=1:n
            a=unique(iter(:,i));
            na=length(a);
            iterinum=[iterinum,na];
        end
        tmax=max(iterinum);
        tx=ones(n,tmax);
        ty=ones(n,tmax);
        for i=1:n
            a=unique(iter(:,i));
            na=length(a);
            e=zeros(1,na-1);
            for k=2:na
                for j=1:ndd
                    if iter(j,i) <= a(k)
                        e(k-1)=e(k-1)+1;
                    end
                end
            end
            e=e./ndd;
            [me,ne]=size(e);
            tx(i,:)=max(a(2:na))*tx(i,:);
            ty(i,:)=max(e)*ty(i,:);
            tx(i,1:na-1)=a(2:na);
            ty(i,1:ne)=e;
        end
       subplot(2,3,3)
         plot(tx(1,:),ty(1,:),'-.','Color',[0.49,0.18,0.56],'linewidth',2)
        hold on
        plot(tx(2,:),ty(2,:),'-.','Color',[0.93,0.69,0.13],'linewidth',2)
        hold on
        plot(tx(3,:),ty(3,:),'-.','Color',[0,0.4470,0.7410],'linewidth',2)
        hold on
        plot(tx(4,:),ty(4,:),'-','Color',[0.85,0.33,0.10],'linewidth',2)
        hold on
        axis([1 7 0 1])
        xlabel('\tau')
        ylabel('\rho(\tau)')
        title('(III) Gradient evaluations','fontname','Times New Roman','Color','k','FontSize',13)
        legend('HZ','PRP+','SD','HZN')
     elseif  dd==4
        k1=[];k2=[];k3=[];k4=[];
       for q1=1:h
            k1=[k1;Mymat14(:,q1)];
            k2=[k2;Mymat24(:,q1)];
         
            k3=[k3;Mymat34(:,q1)];
            k4=[k4;Mymat44(:,q1)];
       end
        R1=zeros(hhh,1);
        R2=zeros(hhh,1);
        R3=zeros(hhh,1);
        R4=zeros(hhh,1);
        for q=1:hhh
            kNCG=k1(q);
            kSD=k2(q);
           
            kPRP1=k3(q);
            kHS1=k4(q);
            R1(q)=kNCG;
            R2(q)=kSD;
           
            R3(q)=kPRP1;
            R4(q)=kHS1;
        end
        R1(find(isnan(R1)))=5000;
        R2(find(isnan(R2)))=5000;
        R3(find(isnan(R3)))=5000;
        R4(find(isnan(R4)))=5000;
        nfsum=[R1 R2 R3 R4];
        iter=nfsum;
        [m,n]=size(iter);
        ndd=m;
        for i=1:ndd
            mi=inf;
            for j=1:n
                if iter(i,j)~=0 && iter(i,j)<mi
                    mi=iter(i,j);
                end
            end
            for j=1:n
                iter(i,j)=iter(i,j)/mi;
            end
        end
        iterinum=[];
        for i=1:n
            a=unique(iter(:,i));
            na=length(a);
            iterinum=[iterinum,na];
        end
        tmax=max(iterinum);
        tx=ones(n,tmax);
        ty=ones(n,tmax);
        for i=1:n
            a=unique(iter(:,i));
            na=length(a);
            e=zeros(1,na-1);
            for k=2:na
                for j=1:ndd
                    if iter(j,i) <= a(k)
                        e(k-1)=e(k-1)+1;
                    end
                end
            end
            e=e./ndd;
            [me,ne]=size(e);
            tx(i,:)=max(a(2:na))*tx(i,:);
            ty(i,:)=max(e)*ty(i,:);
            tx(i,1:na-1)=a(2:na);
            ty(i,1:ne)=e;
        end
       subplot(2,3,4)
         plot(tx(1,:),ty(1,:),'-.','Color',[0.49,0.18,0.56],'linewidth',2)
        hold on
        plot(tx(2,:),ty(2,:),'-.','Color',[0.93,0.69,0.13],'linewidth',2)
        hold on
        plot(tx(3,:),ty(3,:),'-.','Color',[0,0.4470,0.7410],'linewidth',2)
        hold on
        plot(tx(4,:),ty(4,:),'-*','MarkerIndices',1,'Color',[0.85,0.33,0.10],'linewidth',2)
        hold on
       axis([1 5 0 1])
        xlabel('\tau')
        ylabel('\rho(\tau)')
       title('(IV) Vector steepest descent evaluations','fontname','Times New Roman','Color','k','FontSize',13)
        legend('HZ','PRP+','SD','HZN')

   elseif  dd==5
        k1=[];k2=[];k3=[];k4=[];
        for q1=1:h
            k1=[k1;Mymat15(:,q1)];
            k2=[k2;Mymat25(:,q1)];
            k3=[k3;Mymat35(:,q1)];
            k4=[k4;Mymat45(:,q1)];
        end
       
        R1=zeros(hhh,1);
        R2=zeros(hhh,1);
        R3=zeros(hhh,1);
        R4=zeros(hhh,1);
        for q=1:hhh
            kNCG=k1(q);
            kSD=k2(q);
            kPRP1=k3(q);
            kHS1=k4(q);
            R1(q)=kNCG;
            R2(q)=kSD;
            R3(q)=kPRP1;
            R4(q)=kHS1;
        end
        R1(find(isnan(R1)))=5000;
        R2(find(isnan(R2)))=5000;
        R3(find(isnan(R3)))=5000;
        R4(find(isnan(R4)))=5000;
        nfsum=[R1 R2 R3 R4];
        iter=nfsum;
        [m,n]=size(iter);
        ndd=m;
        for i=1:ndd
            mi=inf;
            for j=1:n
                if iter(i,j)~=0 && iter(i,j)<mi
                    mi=iter(i,j);
                end
            end
            for j=1:n
                iter(i,j)=iter(i,j)/mi;
            end
        end
        iterinum=[];
        for i=1:n
            a=unique(iter(:,i));
            na=length(a);
            iterinum=[iterinum,na];
        end
        tmax=max(iterinum);
        tx=ones(n,tmax);
        ty=ones(n,tmax);
        for i=1:n
            a=unique(iter(:,i));
            na=length(a);
            e=zeros(1,na-1);
            for k=2:na
                for j=1:ndd
                    if iter(j,i) <= a(k)
                        e(k-1)=e(k-1)+1;
                    end
                end
            end
            e=e./ndd;
            [me,ne]=size(e);
            tx(i,:)=max(a(2:na))*tx(i,:);
            ty(i,:)=max(e)*ty(i,:);
            tx(i,1:na-1)=a(2:na);
            ty(i,1:ne)=e;
        end
       subplot(2,3,5)
        plot(tx(1,:),ty(1,:),'-.','Color',[0.49,0.18,0.56],'linewidth',2) 
        hold on
        plot(tx(2,:),ty(2,:),'-.','Color',[0.93,0.69,0.13],'linewidth',2)
        hold on
        plot(tx(3,:),ty(3,:),'-.','Color',[0,0.4470,0.7410],'linewidth',2)
        hold on
        plot(tx(4,:),ty(4,:),'-*','MarkerIndices',1,'Color',[0.85,0.33,0.10],'linewidth',2)
        hold on
       axis([1 5 0 1])
        xlabel('\tau')
        ylabel('\rho(\tau)')
        title('(V) CPU time','fontname','Times New Roman','Color','k','FontSize',13)
         legend('HZ','PRP+','SD','HZN')

    end
end



