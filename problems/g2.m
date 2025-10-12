
function g2=g2(x,d)  % IKK1函数
if d==1
g21=2*(x(1)-20);g22=0;
g2=[g21;g22];

elseif d==2  %  TE8
n=length(x);
b=x(1:n-1);
g2=[2*(b-4);2*x(n)];

elseif d==3  %  TE8
n=length(x);
b=x(1:n-1);
g2=[2*(b-4);2*x(n)];

elseif d==4  %  TE8
n=length(x);
b=x(1:n-1);
g2=[2*(b-4);2*x(n)];

elseif d==5  %  MOP5
 
g21=3*(3*x(1)-2*x(2)+4)/4+2*(x(1)-x(2)+1)/27;
g22=-(3*x(1)-2*x(2)+4)/2-2*(x(1)-x(2)+1)/27;
g2=[g21;g22];

elseif d==6  %  MOP7
 
g21=(x(1)+x(2)-3)/18-(-x(1)+x(2)+2)/4;
g22=(x(1)+x(2)-3)/18+(-x(1)+x(2)+2)/4;
g2=[g21;g22];

elseif d==7  %  FDS
n=length(x);
a=x(1:n);
F2=0;
for i=1:n
    f2=x(i)/n;
    F2=f2+F2;
end
g2=exp(F2)/n+2*a;

elseif d==8  %  FDS
n=length(x);
a=x(1:n);
F2=0;
for i=1:n
    f2=x(i)/n;
    F2=f2+F2;
end
g2=exp(F2)/n+2*a;

elseif d==9  %  FDS
n=length(x);
a=x(1:n);
F2=0;
for i=1:n
    f2=x(i)/n;
    F2=f2+F2;
end
g2=exp(F2)/n+2*a;

elseif d==10  %SLCDT2
 a=x(3:end);
g2=[2*(x(1)+1);4*(x(2)+1)^3;2*(a+1)];   
elseif d==12   % Toi8
g2=[8*(2*x(1)-x(2));-4*(2*x(1)-x(2));0];
elseif d==13   %AP1 
g2=[exp((x(1)+x(2))/2)*0.5+2*x(1);exp((x(1)+x(2))/2)*0.5+2*x(2)];   

end
