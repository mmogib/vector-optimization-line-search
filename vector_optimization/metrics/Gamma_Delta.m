
function [Rloopps,data]=Gamma_Delta(P1,P2,P3,P4)
% P1: Approximation of Pareto set, P=paretofront(F1);
% P2: Approximation of Pareto set, P=paretofront(F2);
% P3: Approximation of Pareto set, P=paretofront(F3);
% P4: Approximation of Pareto set, P=paretofront(F4);
% F1: a solution set found by HZN method on a problem.
% F2: a solution set found by HZ method on a problem.
% F3: a solution set found by PRP+ method on a problem.
% F4: a solution set found by SD method on a problem.
s=4;
Rloopps=zeros(1,s);
data=zeros(1,s);
HH1=union(P1,P2,'rows');
HH2=union(P3,P4,'rows');
HH=union(HH1,HH2,'rows');

Z1=P1;
z1=size(Z1,1);

Z2=P2;
z2=size(Z2,1);

Z3=P3;
z3=size(Z3,1);

Z4=P4;
z4=size(Z4,1);

x_01=[];
for i=1:m
x_01=[x_01,min(HH(:,i))];
end
x_N11=[];
for i=1:m
x_N11=[x_N11,max(HH(:,i))];
end

x_02=[];
for i=1:m
x_02=[x_02,min(HH(:,i))];
end
x_N12=[];
for i=1:m
x_N12=[x_N12,max(HH(:,i))];
end

x_03=[];
for i=1:m
x_03=[x_03,min(HH(:,i))];
end
x_N13=[];
for i=1:m
x_N13=[x_N13,max(HH(:,i))];
end

x_04=[];
for i=1:m
x_04=[x_04,min(HH(:,i))];
end
x_N14=[];
for i=1:m
x_N14=[x_N14,max(HH(:,i))];
end

FF1= sort(Z1,'ascend');
        kk1=[];
        a11=[];
        d11=[];
        for j=1:m
            kk2=(FF1(1,j)-x_01(j));
            %kk2=0;
            b11=[];
            for i=1:z1-1
                a1=(FF1(i+1,j)-FF1(i,j));
                b11=[b11;a1];
                kk2=[kk2;a1];
            end
            c11=sum(b11)/(z1-1);
            a11=[a11;c11];
            g1=(x_N11(j)-FF1(z1,j));
            kk2=[kk2;g1];
            c1=max(kk2);
            kk1=[kk1;c1];
            d11=[d11;sum(abs(b11-c11))];
        end
        ka1=max(kk1);
FF2= sort(Z2,'ascend');
        kk2=[];
        a12=[];
        d12=[];
        for j=1:m
           kk3=(FF2(1,j)-x_02(j));
          % kk3=0;
            b12=[];
            for i=1:z2-1
                a2=(FF2(i+1,j)-FF2(i,j));
                b12=[b12;a2];
                kk3=[kk3;a2];
            end
            c12=sum(b12)/(z2-1);
            a12=[a12;c12];
            g2=(x_N12(j)-FF2(z2,j));
            kk3=[kk3;g2];
            c2=max(kk3);
            kk2=[kk2;c2];
            d12=[d12;sum(abs(b12-c12))];
        end
        ka2=max(kk2);

FF3= sort(Z3,'ascend');
        kk3=[];
        a13=[];
        d13=[];
        for j=1:m
            kk4=(FF3(1,j)-x_03(j));
            %kk4=0;
            b13=[];
            for i=1:z3-1
                a3=(FF3(i+1,j)-FF3(i,j));
                b13=[b13;a3];
                kk4=[kk4;a3];
            end
            c13=sum(b13)/(z3-1);
            a13=[a13;c13];
            g3=(x_N13(j)-FF3(z3,j));
            kk4=[kk4;g3];
            c3=max(kk4);
            kk3=[kk3;c3];
            d13=[d13;sum(abs(b13-c13))];
        end
        ka3=max(kk3);

FF4= sort(Z4,'ascend');
        kk4=[];
        a14=[];
        d14=[];
        for j=1:m
            kk5=(FF4(1,j)-x_04(j));
           % kk5=0;
            b14=[];
            for i=1:z4-1
                a4=(FF4(i+1,j)-FF4(i,j));
                b14=[b14;a4];
                kk5=[kk5;a4];
            end
            c14=sum(b14)/(z4-1);
            a14=[a14;c14];
            g4=(x_N14(j)-FF4(z4,j));
            kk5=[kk5;g4];
            c4=max(kk5);
            kk4=[kk4;c4];
            d14=[d14;sum(abs(b14-c14))];
        end
        ka4=max(kk4);
Rloopps(:,1:s)=[ka1,ka2,ka3,ka4];

da1=[];
for j=1:m
    de1=((FF1(1,j)-x_01(j))+(x_N11(j)-FF1(z1,j))+d11(j))/((FF1(1,j)-x_01(j))+(x_N11(j)-FF1(z1,j))+(z1-1)*a11(j));
    da1=[da1;de1];
end
data1=max(da1);
da2=[];
for j=1:m
    de2=((FF2(1,j)-x_02(j))+(x_N12(j)-FF2(z2,j))+d12(j))/((FF2(1,j)-x_02(j))+(x_N12(j)-FF2(z2,j))+(z2-1)*a12(j));
    da2=[da2;de2];
end
data2=max(da2);

da3=[];
for j=1:m
    de3=((FF3(1,j)-x_03(j))+(x_N13(j)-FF3(z3,j))+d13(j))/((FF3(1,j)-x_03(j))+(x_N13(j)-FF3(z3,j))+(z3-1)*a13(j));
    da3=[da3;de3];
end
data3=max(da3);

da4=[];
for j=1:m
    de4=((FF4(1,j)-x_04(j))+(x_N14(j)-FF4(z4,j))+d14(j))/((FF4(1,j)-x_04(j))+(x_N14(j)-FF4(z4,j))+(z4-1)*a14(j));
    da4=[da4;de4];
end
data4=max(da4);
data(:,1:s)=[data1,data2,data3,data4];
