% function g=g(x)%keyi   %   MGH16
% g=[];
% m=10;
% for l=1:m
%     g1=2*(x(1)+l/5*x(2)-exp(l/5));
%     g2=(2*l/5)*(x(1)+l/5*x(2)-exp(l/5));
%     g3=2*(x(3)+x(4)*sin(l/5)-cos(l/5));
%     g4=(2*sin(l/5))*(x(3)+x(4)*sin(l/5)-cos(l/5));
%     g=[g;g1,g2,g3,g4];
%  end

%  function g=g(x)    %  MGH26
%  n=length(x);
%  m=length(x);
%  a=0;
%  for i=1:n
%      a=a+cos(x(i));
%  end
%  g=zeros(m,n);
%  b=[];
%  for i=1:n
%     b=[b,sin(x(i))];
%  end
%  for l=1:n
%  g(l,:)=b*2*(4-a+l*(1-cos(x(l)))-sin(x(l)));
%  end
% for l=1:n
% g(i,i)=((i+1)*sin(x(i))-cos(x(i)))*2*(4-a+l*(1-cos(x(l)))-sin(x(l)));
% end
% end

% function g=g(x)  % Toi9
% m=length(x);
% n=m;
% g=zeros(m,n);
% g(1,1)=4*(2*x(1)-1);
% g(1,2)=2*x(2);
% for i=2:m-1
% g(i,i-1)=2*i*(2*x(i-1)-x(i))*2-2*(i-1)*x(i-1);
% g(i,i)=2*i*(2*x(i-1)-x(i))*(-1)+2*i*x(i);
% end
% g(m,m-1)=2*m*(2*x(m-1)-x(m))*2-2*(m-1)*x(m-1);
% g(m,m)=2*m*(2*x(m-1)-x(m))*(-1);


% function g=g(x)    % MGH33
% m=length(x);
% n=length(x);
% a=0;
% for j=1:10
%     a1=j*x(j);
%     a=a+a1;
% end
% g=[];
% for i=1:m
%  g1=[i*1*(i*a-1)*2,i*2*(i*a-1)*2,i*3*(i*a-1)*2,i*4*(i*a-1)*2,i*5*(i*a-1)*2,i*6*(i*a-1)*2,i*7*(i*a-1)*2,i*8*(i*a-1)*2,i*9*(i*a-1)*2,i*10*(i*a-1)*2];
%  g=[g;g1];
% end

function g=g(x)   %Toi10
m=length(x)-1;
n=length(x);
g=zeros(m,n);
for i=1:m
    g(i,i)=2*100*(x(i+1)-x(i)^2)*(-2*x(i));
    g(i,i+1)=2*100*(x(i+1)-x(i)^2)+2*(x(i+1)-1);
end

% function g=g(x)   % MGH13 
% g1=[1,10,0,0];
% g2=[0,0,sqrt(5),-sqrt(5)];
% g3=[0,2*(x(2)-2*x(3)),-4*(x(2)-2*x(3)),0];
% g4=[2*sqrt(10)*(x(1)-x(4)),0,0,-2*sqrt(10)*(x(1)-x(4))];
% g=[g1;g2;g3;g4];

% function g=g(x)   %12 MGH27
% m=length(x);
% n=length(x);
% gg=ones(m-1,n);
% for i=1:m-1
%     gg(i,i)=2;
% end
% g1=[];
% for i=1:n
%     g11=prod(x)/x(i);
%     g1=[g1,g11];
% end
% g=[gg;g1];


% function g=g(x) %MGH28  
% n=length(x);
% m=length(x);
% g=zeros(m,n);
% g(m,n)=2+3*(1/(n+1)^2)*0.5*(x(n)+m/(n+1)+1)^2;
% for i=1:n-1
% g(i,i)=2+3*(1/(n+1)^2)*0.5*(x(i)+i/(n+1)+1)^2;
% g(i,i+1)=-1;
% g(i+1,i)=-1;
% end

% function g=g(x) %MGH8
% g=[];
% for i=1:15
%     if i==1
%         yi=0.14;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==2
%         yi=0.18;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==3
%         yi=0.22;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==4
%         yi=0.25;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==5
%         yi=0.29;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==6
%         yi=0.32;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==7
%         yi=0.35;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==8
%         yi=0.39;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==9
%         yi=0.37;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==10
%         yi=0.58;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==11
%         yi=0.73;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==12
%        yi=0.96;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==13
%         yi=1.34;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==14
%         yi=2.1;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     elseif i==15
%         yi=4.39;vi=16-i;
%         ui=i; wi=min(ui,vi);
%     end
%     g11=-1;
%     g12=ui*vi/(vi*x(2)+wi*x(3))^2;
%     g13=ui*wi/(vi*x(2)+wi*x(3))^2;
%     g=[g;g11,g12,g13];
% end

% function g=g(x) %MGH12
% g=[];
% m=50;
% for i=1:m
%     g11=-i/10*exp(-i/10*x(1));
%     g12=-i/10*exp(-i/10*x(2));
%     g13=-exp(-i/10)+exp(-i);
%     g=[g;g11,g12,g13];
% end


