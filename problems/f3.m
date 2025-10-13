function f3=f3(x,d)  % IKK1函数
if d==1
  f3 = x(2)^2;

elseif d==2 || d==3 || d==4   %  TE8 (consolidated)
  F = te8_f(x); f3 = F(3);

elseif d==5   %  MOP5
  f3 = 1/(x(1)^2+x(2)^2+1)-1.1*exp(-x(1)^2-x(2)^2);

elseif d==6   %  MOP7
  f3 = (x(1)+2*x(2)-1)^2/175+(-x(1)+2*x(2))^2/17-13;

elseif d==7 || d==8 || d==9   %  FDS (consolidated)
  F = fds_f(x); f3 = F(3);

elseif d==10  %SLCDT2
  f3 = (x(1)-1)^2+(x(2)+1)^2+(x(3)-1)^4+(x(4)+1)^2+(x(5)-1)^2+(x(6)+1)^2+(x(7)-1)^2+(x(8)+1)^2+(x(9)-1)^2+(x(10)+1)^2;
elseif d==11 % Toi8
  f3 = 3*(2*x(2)-x(3))^2;
elseif d==12  %AP1 
  f3 = 1/6*(exp(-x(1))+2*exp(-x(2)));

end
end
