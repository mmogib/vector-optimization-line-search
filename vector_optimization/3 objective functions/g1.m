
function g1=g1(x,d)   % IKK1
if d==1
g11=2*x(1);g12=0;
g1=[g11;g12];

elseif d==2  %  TE8
n=length(x);
a=x(1:n);
g1=3*a.^2;

elseif d==3   %  TE8
n=length(x);
a=x(1:n);
g1=3*a.^2;

elseif d==4   %  TE8
n=length(x);
a=x(1:n);
g1=3*a.^2;

elseif d==5   %  MOP5
 
g11=x(1)+2*x(1)*cos(x(1)^2+x(2)^2);
g12=x(2)+2*x(2)*cos(x(1)^2+x(2)^2);
g1=[g11;g12];

elseif d==6   %  MOP7
 
g11=x(1)-2;g12=2*(x(2)+1)/13;
g1=[g11;g12];

elseif d==7   %  FDS
n=length(x);
a=x(1:n);
b=(1:n);
g1=(4/n^2)*b'.*(a-b').^3;

elseif d==8  %  FDS
n=length(x);
a=x(1:n);
b=(1:n);
g1=(4/n^2)*b'.*(a-b').^3;

elseif d==9   %  FDS
n=length(x);
a=x(1:n);
b=(1:n);
g1=(4/n^2)*b'.*(a-b').^3;

elseif d==10   %SLCDT2
a=x(2:end);
g1=[4*(x(1)-1)^3;2*(a-1)];
elseif d==11   % Toi8
g1=[4*(2*x(1)-1);0;0];
elseif d==12   %AP1 
 g1=[(x(1)-1)^3;2*(x(2)-2)^3];

end