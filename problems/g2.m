
function g2=g2(x,d)  % IKK1函数
if d==1
  g2=[2*(x(1)-20);0];

elseif d==2 || d==3 || d==4  %  TE8 (consolidated)
  G = te8_g(x); g2 = G{2};

elseif d==5  %  MOP5
  g21=3*(3*x(1)-2*x(2)+4)/4+2*(x(1)-x(2)+1)/27;
  g22=-(3*x(1)-2*x(2)+4)/2-2*(x(1)-x(2)+1)/27;
  g2=[g21;g22];

elseif d==6  %  MOP7
  g21=(x(1)+x(2)-3)/18-(-x(1)+x(2)+2)/4;
  g22=(x(1)+x(2)-3)/18+(-x(1)+x(2)+2)/4;
  g2=[g21;g22];

elseif d==7 || d==8 || d==9  %  FDS (consolidated)
  G = fds_g(x); g2 = G{2};

elseif d==10  %SLCDT2
  a=x(3:end);
  g2=[2*(x(1)+1);4*(x(2)+1)^3;2*(a+1)];
elseif d==12   % Toi8
  g2=[8*(2*x(1)-x(2));-4*(2*x(1)-x(2));0];
elseif d==13   %AP1 
  g2=[exp((x(1)+x(2))/2)*0.5+2*x(1);exp((x(1)+x(2))/2)*0.5+2*x(2)];   

end
