
% function f=f(x)  %MGH16   
% f=[];
% m=10;
% for l=1:m
%     f1=(x(1)+l/5*x(2)-exp(l/5))^2+(x(3)+x(4)*sin(l/5)-cos(l/5))^2;
%     f=[f;f1];
% end
% end

% function f=f(x)  %MGH26  
% f=[];
% n=length(x);
% a=0;
% for i=1:n
%     a=a+cos(x(i));
% end
% for l=1:n
%     f1=(4-a+l*(1-cos(x(l)))-sin(x(l)))^2;
%     f=[f;f1];
% end
% end

% function f=f(x)  %     Toi9
% f=[];
% m=length(x);
% %n=m;
% f1=(2*x(1)-1)^2+x(2)^2;
% f=[f;f1];
% for i=2:m-1
% ff=i*(2*x(i-1)-x(i))^2-(i-1)*x(i-1)^2+i*x(i)^2;
% f=[f;ff];
% end
% fm=m*(2*x(m-1)-x(m))^2-(m-1)*x(m-1)^2;
% f=[f;fm];

% function f=f(x)   %MGH33 
% m=length(x);
% n=length(x);
% a=0;
% for j=1:10
%     a1=j*x(j);
%     a=a+a1;
% end
% f=[];
% for i=1:m
%     f1=(i*a-1)^2;
%     f=[f;f1];
% end

function f=f(x)  % Toi10
f=[];
m=length(x)-1;
for i=1:m
    fi=100*(x(i+1)-x(i)^2)^2+(x(i+1)-1)^2;
    f=[f;fi];
end

% function f=f(x)  %mgh13  10  m=n=4  -1-1
% f1=x(1)+10*x(2);
% f2=sqrt(5)*(x(3)-x(4));
% f3=(x(2)-2*x(3))^2;
% f4=sqrt(10)*(x(1)-x(4))^2;
% f=[f1;f2;f3;f4];


% function f=f(x)% MGH27 MGH271 (50,100),MGH272(1000)
% ff=[];
% m=length(x);
% n=length(x);
% for i=1:m-1
%     f1=x(i)+sum(x)-(n+1);
%     ff=[ff;f1];
% end
% f2=prod(x)-1;
% f=[ff;f2];

% function f=f(x) %MGH28  
% n=length(x);
% m=length(x);
% f2=[];
% f1=2*x(1)-x(1+1)+(1/(n+1))^2*(x(1)+1/(n+1)+1)^3;
% fm=2*x(n)-x(n-1)+(1/(n+1))^2*(x(n)+n/(n+1)+1)^3;
% for i=2:m-1
% ff=2*x(i)-x(i-1)-x(i+1)+(1/(n+1))^2*(x(i)+i/(n+1)+1)^3;
% f2=[f2;ff];
% end
% f=[f1;f2;fm];

% function f=f(x) %MGH8
% f=[];
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
%     f1=yi-(x(1)+ui/(vi*x(2)+wi*x(3)));
%     f=[f;f1];
% end

% function f=f(x) %MGH12 
% f=[];
% m=50;
% for i=1:m
%     f1=exp(-i/10*x(1))-exp(-i/10*x(2))-x(3)*(exp(-i/10)-exp(-i));
%     f=[f;f1];
% end




