
function f3=f3(x,d)  % IKK1函数
if d==1
f3=x(2)^2;

elseif d==2   %  TE8
 
n=length(x);
F3=0;
for i=2:n
    c=5*x(i)^2;
    F3=F3+c;
end
f3=-log(x(1))+F3;

elseif d==3  %  TE8
 
n=length(x);
F3=0;
for i=2:n
    c=5*x(i)^2;
    F3=F3+c;
end
f3=-log(x(1))+F3;

elseif d==4   %  TE8
 
n=length(x);
F3=0;
for i=2:n
    c=5*x(i)^2;
    F3=F3+c;
end
f3=-log(x(1))+F3;
elseif d==5   %  MOP5
 
f3=1/(x(1)^2+x(2)^2+1)-1.1*exp(-x(1)^2-x(2)^2);

elseif d==6   %  MOP7
 
f3=(x(1)+2*x(2)-1)^2/175+(-x(1)+2*x(2))^2/17-13;

elseif d==7   %  FDS
 
n=length(x);
F3=0;
for i=1:n
    a=i*(n-i+1)*exp(-x(i));
    F3=a+F3;
end
f3=F3/(n*(n+1));

elseif d==8  %  FDS
 
n=length(x);
F3=0;
for i=1:n
    a=i*(n-i+1)*exp(-x(i));
    F3=a+F3;
end
f3=F3/(n*(n+1));

elseif d==9  %  FDS 
 
n=length(x);  
F3=0;
for i=1:n
    a=i*(n-i+1)*exp(-x(i));
    F3=a+F3;
end
f3=F3/(n*(n+1));

elseif d==10  %SLCDT2
 f3=(x(1)-1)^2+(x(2)+1)^2+(x(3)-1)^4+(x(4)+1)^2+(x(5)-1)^2+(x(6)+1)^2+(x(7)-1)^2+(x(8)+1)^2+(x(9)-1)^2+(x(10)+1)^2;
elseif d==11 % Toi8
f3=3*(2*x(2)-x(3))^2;
elseif d==12  %AP1 
 f3=1/6*(exp(-x(1))+2*exp(-x(2)));

end
end
