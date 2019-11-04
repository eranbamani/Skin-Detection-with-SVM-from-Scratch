%ERAN BAMANI
%17.12.18
%SGD fun
%===============================================
function w=SGD(mat,y,C,Epoch_Times)
w=zeros(1,4);
n=length(y);
for t=1:Epoch_Times*size(mat,1)
%for t=1:Epoch_Times*1000
i=randi(length(y));
  % for i=1:length(y)
       x=[mat(i,:) 1];
       %x=x';
    %%subgradient
    if 1-y(i)*(w*x')<=0
        w=w-(1/t)*(w/n);
    else
        w=w-(1/t)*(w/n-C*y(i)*x);
    end
   %end
end 