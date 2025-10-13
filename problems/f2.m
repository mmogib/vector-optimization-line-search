
function f2=f2(x,d)  % IKK1函数
if d==1
  f2 = (x(1)-20)^2;

elseif d==2 || d==3 || d==4  % TE8 (consolidated)
  F = te8_f(x); f2 = F(2);

elseif d==5   %  MOP5
  f2 = (3*x(1)-2*x(2)+4)^2/8+(x(1)-x(2)+1)^2/27+15;

elseif d==6  %  MOP7
  f2 = (x(1)+x(2)-3)^2/36+(-x(1)+x(2)+2)^2/8-17;

elseif d==7 || d==8 || d==9   %  FDS (consolidated)
  F = fds_f(x); f2 = F(2);

elseif d==10 %SLCDT2
  f12=0; for i=3:10, f12 = f12 + (x(i)+1)^2; end
  f2 = f12 + (x(1)+1)^2 + (x(2)+1)^4;

elseif d==11   % Toi8
  f2 = 2*(2*x(1)-x(2))^2;

elseif d==12  %AP1 
  f2 = exp((x(1)+x(2))/2)+x(1)^2+x(2)^2;
end
end
