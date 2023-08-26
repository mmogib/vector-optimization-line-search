function f2=f2(x,d)
if d==1 % BK1
        f2=(x(1)-5)^2+(x(2)-5)^2;
        
elseif d==2% DGO1
       f2=sin(x+0.7);
        
elseif d==3% DGO2
       f2=9-sqrt(81-x^2);

elseif d==4% FF1
 
 f2=1-exp(-(x(1)+1)^2-(x(2)-1)^2);

 elseif d==5%  JOS1
n=length(x);
F2=0;
for i=1:n
    b=(x(i)-2)^2/n;
    F2=F2+b;
end
f2=F2;

 elseif d==6%  JOS1
n=length(x);
F2=0;
for i=1:n
    b=(x(i)-2)^2/n;
    F2=F2+b;
end
f2=F2;

 elseif d==7%  JOS1
n=length(x);
F2=0;
for i=1:n
    b=(x(i)-2)^2/n;
    F2=F2+b;
end
f2=F2;

elseif d==8%  MLF1
 
 f2=(1+x/20)*cos(x);

 elseif d==9%  MLF2
 
f2=-(5-((4*x(1)^2+2*x(2)-11)^2+(2*x(1)+4*x(2)^2-7)^2)/200);

elseif d==10%  TE1
 
 f2=x(1)^2+0.5*x(2)^2-10*x(2)-100;

elseif d==11%  TE2
 
f2=1-exp(-(x(1)-1/sqrt(2))^2-(x(2)-1/sqrt(2))^2);

elseif d==12%  TE4
n=length(x);
F2=0;
for i=1:n
    b=x(i);
    F2=F2+b;
end
f2=F2-2;

elseif d==13%  TE6
 
f2=x(1)^2+x(2);

elseif d==14%  TE7
 
n=length(x);
F(2)=0;
for i=1:n
    b=x(i);
    F(2)=F(2)+b;
end
f2=F(2);

elseif d==15%  SP1
 
 f2=(x(2)-3)^2+(x(1)-x(2))^2;

elseif d==16%  SSFYY2函数
 
 f2=(x-4)^2;

elseif d==17%  SK1
 
 f2=-(-0.5*x^4+2*x^3+10*x^2-10*x+5);
elseif d==18% SK2
 
b=x(1)^2+x(2)^2+x(3)^2+x(4)^2;
f2=-((sin(x(1))+sin(x(2))+sin(x(3))+sin(x(4)))/(1+b/100));
elseif d==19%  VU1
 
 f2=x(1)^2+3*x(2)^2+1;

elseif d==20%  MOP1
  f2=(x-2)^2;

elseif d==21%  MOP2
 
n=length(x);
f2=0;
for i=1:n
    b=(x(i)+1/sqrt(n))^2;
    f2=f2+b;
end
f2=1-exp(-f2);

elseif d==22%  MOP3
 
 f2=-(-(x(1)+3)^2-(x(2)+1)^2);

elseif d==23%  DD1
 
 f2=3*x(1)+2*x(2)-x(3)/3+0.01*(x(4)-x(5))^3;

elseif d==24%  Toi4函数
 
 f2=0.5*((x(1)-x(2))^2+(x(3)-x(4))^2)+1;

elseif d==25%  Hill
 
a=(2*pi/360)*(45+40*sin(2*pi*x(1))+25*sin(2*pi*x(2)));
b=1+0.5*cos(2*pi*x(1));
f2=b*sin(a);

elseif d==26%  PNR
 
k=1;l=0;
f2=(x(1)-k)^2+(x(2)-l)^2;

elseif d==27% MMR1
 
 f2=(2-0.8*exp(-((x(2)-0.6)/0.4)^2)-exp(-((x(2)-0.2)/0.04)^2))/(1+x(1)^2);

elseif d==28 %AP3
    f2=(x(2)-x(1)^2)^2+(1-x(1))^2;

elseif d==29  %Lov5
    M=[-1,-0.03,0.011;-0.03,-1,0.07;0.011,0.07,-1.01];
    ff=sqrt(2*pi/0.35)*exp(([x(1);x(2)-0.15;x(3)]'*M*[x(1);x(2)-0.15;x(3)])/0.35^2)+sqrt(2*pi/3)*exp(([x(1);x(2)+1.1;0.5*x(3)]'*M*[x(1);x(2)+1.1;0.5*x(3)])/3^2);
    f2=-sqrt(2)/2*x(1)+sqrt(2)/2*ff;
end
