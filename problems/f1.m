function f1=f1(x,d) % IKK1 
if d==1
f1=x(1)^2;

elseif d==2 %  TE8
n=length(x);
f1=0;
for i=1:n
    a=x(i)^3;
    f1=f1+a;
end

elseif d==3  %  TE8
 
n=length(x);
f1=0;
for i=1:n
    a=x(i)^3;
    f1=f1+a;
end

elseif d==4 %  TE8
 
n=length(x);
f1=0;
for i=1:n
    a=x(i)^3;
    f1=f1+a;
end

elseif d==5   %  MOP5
 
 f1=0.5*(x(1)^2+x(2)^2)+sin(x(1)^2+x(2)^2);

elseif d==6 %  MOP7
 
 f1=(x(1)-2)^2/2+(x(2)+1)^2/13+3;

elseif d==7 %  FDS
 
n=length(x);F1=0;
for i=1:n
    a=i*(x(i)-i)^4;
    F1=a+F1;
end
f1=F1/n^2;

elseif d==8  %  FDS
 
n=length(x);F1=0;
for i=1:n
    a=i*(x(i)-i)^4;
    F1=a+F1;
end
f1=F1/n^2;

elseif d==9  %  FDS
 
n=length(x);F1=0;
for i=1:n
    a=i*(x(i)-i)^4;
    F1=a+F1;
end
f1=F1/n^2;

 elseif d==10  %SLCDT2
      f11=0;
for i=2:10
    f12=(x(i)-1)^2;
    f11=f12+f11;
end
f1=f11+(x(1)-1)^4;

elseif d==11  % Toi8
    f1=(2*x(1)-1)^2;

elseif d==12  %AP1 
  f1=1/4*((x(1)-1)^4+2*(x(2)-4)^4); 
end
end