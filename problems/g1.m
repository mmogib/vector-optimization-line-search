function g1=g1(x,d)   % IKK1
if d==1
  g1 = [2*x(1); 0];

elseif d==2 || d==3 || d==4  %  TE8 (consolidated)
  G = te8_g(x); g1 = G{1};

elseif d==5   %  MOP5
  g11=x(1)+2*x(1)*cos(x(1)^2+x(2)^2);
  g12=x(2)+2*x(2)*cos(x(1)^2+x(2)^2);
  g1=[g11;g12];

elseif d==6   %  MOP7
  g11=x(1)-2; g12=2*(x(2)+1)/13; g1=[g11;g12];

elseif d==7 || d==8 || d==9   %  FDS (consolidated)
  G = fds_g(x); g1 = G{1};

elseif d==10   %SLCDT2
  a=x(2:end);
  g1=[4*(x(1)-1)^3;2*(a-1)];
elseif d==11   % Toi8
  g1=[4*(2*x(1)-1);0;0];
elseif d==12   %AP1 
  g1=[(x(1)-1)^3;2*(x(2)-2)^3];

end
