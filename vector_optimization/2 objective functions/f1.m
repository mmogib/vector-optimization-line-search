function f1=f1(x,d)
 if d==1 % BK1
    f1=x(1)^2+x(2)^2;
        
 elseif d==2 % DGO1
        f1=sin(x);
        
 elseif d==3  % DGO2
        f1=x^2;
        
 elseif d==4  % FF1
 f1=1-exp(-(x(1)-1)^2-(x(2)+1)^2);
  
elseif d==65%  JOS1
n=length(x);
F1=0;
for i=1:n
    a=x(i)^2/n;
    F1=F1+a;
end
f1=F1;

elseif d==6%  JOS1
n=length(x);
F1=0;
for i=1:n
    a=x(i)^2/n;
    F1=F1+a;
end
f1=F1;

elseif d==7%  JOS1
n=length(x);
F1=0;
for i=1:n
    a=x(i)^2/n;
    F1=F1+a;
end
f1=F1;

 elseif d==8%  MLF1
 f1=(1+x/20)*sin(x);

 elseif d==9%  MLF2
 f1=-(5-((x(1)^2+x(2)-11)^2+(x(1)+x(2)^2-7)^2)/200);

 elseif d==10%  TE1
 f1=0.5*x(1)^2+x(2)^2-10*x(1)-100;

 elseif d==11%  TE2
 f1=sin(x(2));

 elseif d==12%  TE4 
n=length(x);F1=0;
for i=1:n-1
    a=x(i)^2;
    F1=F1+a;
end
f1=F1+2;

 elseif d==13%  TE6
f1=-log(x(1))-log(x(2));

elseif d==14%  TE7
n=length(x);F(1)=0;
for i=1:n
    a=x(i)^4+x(i)^3;
    F(1)=F(1)+a;
end
f1=F(1);

elseif d==15%  SP1
 f1=(x(1)-1)^2+(x(1)-x(2))^2;

elseif d==16%  SSFYY2
 f1=10+x^2-10*cos(x*pi/2);

elseif d==17%  SK1函数
 f1=-(-x^4-3*x^3+10*x^2+10*x+10);
 
elseif d==18% SK2
 f1=(x(1)-2)^2+(x(2)+3)^2+(x(3)-5)^2+(x(4)-4)^2-5;
 
elseif d==19%  VU1
f1=1/(x(1)^2+x(2)^2+1);

elseif d==20%  MOP1
f1=x^2;

elseif d==21%  MOP2
n=length(x);
f1=0;
for i=1:n
    a=(x(i)-1/sqrt(n))^2;
    f1=f1+a;
end
f1=1-exp(-f1);

elseif d==22%  MOP3
A1=0.5*sin(1)-2*cos(1)+sin(2)-1.5*cos(2);
A2=1.5*sin(1)-cos(1)+2*sin(2)-0.5*cos(2);
B1=0.5*sin(x(1))-2*cos(x(1))+sin(x(2))-1.5*cos(x(2));
B2=1.5*sin(x(1))-cos(x(1))+2*sin(x(2))-0.5*cos(x(2));
f1=-(-1-(A1-B1)^2-(A2-B2)^2);

elseif d==23%  DD1
 f1=x(1)^2+x(2)^2+x(3)^2+x(4)^2+x(5)^2;

elseif d==24%  Toi4
 f1=x(1)^2+x(2)^2+1;

elseif d==25%  Hill
a=(2*pi/360)*(45+40*sin(2*pi*x(1))+25*sin(2*pi*x(2)));
b=1+0.5*cos(2*pi*x(1));
f1=b*cos(a);

 elseif d==26%  PNR
     c=10;d=0.25;
     f1=x(1)^4+x(2)^4+x(1)^2+x(2)^2+c*x(1)*x(2)+d*x(1)+20;

 elseif d==27% MMR1
     f1=1+x(1)^2;

 elseif d==28  %AP3
     f1=1/4*((x(1)-4)^4+2*(x(2)-2)^4);

 elseif d==29  %Lov5
     M=[-1,-0.03,0.011;-0.03,-1,0.07;0.011,0.07,-1.01];
     ff=sqrt(2*pi/0.35)*exp(([x(1);x(2)-0.15;x(3)]'*M*[x(1);x(2)-0.15;x(3)])/0.35^2)+sqrt(2*pi/3)*exp(([x(1);x(2)+1.1;0.5*x(3)]'*M*[x(1);x(2)+1.1;0.5*x(3)])/3^2);
     f1=sqrt(2)/2*x(1)+sqrt(2)/2*ff;
 end

