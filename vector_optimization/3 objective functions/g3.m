
function g3=g3(x,d)  % IKK1函数
if d==1
g31=0;g32=2*x(2);
g3=[g31;g32];

elseif d==2  %  TE8
n=length(x);
c=x(2:n);
g3=[-1/x(1);10*c];

elseif d==3  %  TE8
n=length(x);
c=x(2:n);
g3=[-1/x(1);10*c];

elseif d==4  %  TE8
n=length(x);
c=x(2:n);
g3=[-1/x(1);10*c];

elseif d==5  %  MOP5
 
g31=-2*x(1)/(x(1)^2+x(2)^2+1)^2+2.2*x(1)*exp(-x(1)^2-x(2)^2);
g32=-2*x(2)/(x(1)^2+x(2)^2+1)^2+2.2*x(1)*exp(-x(1)^2-x(2)^2);
g3=[g31;g32];

elseif d==6  %  MOP7
 
g31=2*(x(1)+2*x(2)-1)/175-2*(-x(1)+2*x(2))/17;
g32=4*(x(1)+2*x(2)-1)/175+4*(-x(1)+2*x(2))/17;
g3=[g31;g32];

elseif d==7  %  FDS
n=length(x);
a=x(1:n);
b=(1:n);
c=sort(b,'descend');
g3=-(1/(n*(n+1)))*(b'.*c').*exp(-a);

elseif d==8  %  FDS
n=length(x);
a=x(1:n);
b=(1:n);
c=sort(b,'descend');
g3=-(1/(n*(n+1)))*(b'.*c').*exp(-a);

elseif d==9  %  FDS
n=length(x);
a=x(1:n);
b=(1:n);
c=sort(b,'descend');
g3=-(1/(n*(n+1)))*(b'.*c').*exp(-a);

elseif d==10   %SLCDT2
 g3=[2*(x(1)-1);2*(x(2)+1);4*(x(3)-1)^3;2*(x(4)+1);2*(x(5)-1);2*(x(6)+1);2*(x(7)-1);2*(x(8)+1);2*(x(9)-1);2*(x(10)+1)]; 
 elseif d==12  % Toi8
g3=[0;12*(2*x(2)-x(3));-6*(2*x(2)-x(3))];
elseif d==13  %AP1 
g3=[exp(-x(1))*(-1/6);exp(-x(2))*(-1/3)];    

end