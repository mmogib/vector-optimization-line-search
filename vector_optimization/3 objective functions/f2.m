
function f2=f2(x,d)  % IKK1函数
if d==1
f2=(x(1)-20)^2;

elseif d==2  %  TE8
 
n=length(x);
F2=0;
for i=1:n-1
    b=(x(i)-4)^2;
    F2=F2+b;
end
f2=F2+x(n)^2;

elseif d==3   %  TE8
 
n=length(x);
F2=0;
for i=1:n-1
    b=(x(i)-4)^2;
    F2=F2+b;
end
f2=F2+x(n)^2;

elseif d==4  %  TE8
 
n=length(x);
F2=0;
for i=1:n-1
    b=(x(i)-4)^2;
    F2=F2+b;
end
f2=F2+x(n)^2;

elseif d==5   %  MOP5
 
f2=(3*x(1)-2*x(2)+4)^2/8+(x(1)-x(2)+1)^2/27+15;

elseif d==6  %  MOP7
 
f2=(x(1)+x(2)-3)^2/36+(-x(1)+x(2)+2)^2/8-17;

elseif d==7   %  FDS
 
n=length(x);
F2=0;
for i=1:n
    a=x(i)/n;
    F2=a+F2;
end
f2=exp(F2)+norm(x,2)^2;

elseif d==8  %  FDS
 
n=length(x);
F2=0;
for i=1:n
    a=x(i)/n;
    F2=a+F2;
end
f2=exp(F2)+norm(x,2)^2;

elseif d==9   %  FDS
 
n=length(x);
F2=0;
for i=1:n
    a=x(i)/n;
    F2=a+F2;
end
f2=exp(F2)+norm(x,2)^2;

elseif d==10 %SLCDT2
    f12=0;
for i=3:10
    f13=(x(i)+1)^2;
    f12=f13+f12;
end
f2=f12+(x(1)+1)^2+(x(2)+1)^4;
elseif d==11   % Toi8
    f2=2*(2*x(1)-x(2))^2;
elseif d==12  %AP1 
    f2=exp((x(1)+x(2))/2)+x(1)^2+x(2)^2;
end
end
