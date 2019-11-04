%ERAN BAMANI
%14.12.18
%Main SVM
%===============================================
%data
data=textread('Skin_NonSkin.txt');
%-------------------------------------
% Pre Processing
randsegment=randi([1,size(data,1)],1,size(data,1));
data=data(randsegment,:);
Percent=0.7;
x=data(:,1:3);
y=data(:,4);
[r,c]=find(y==2);
data(r,4)=-1;
y(r)=-1;
C=[2^-5  2^-3 2^-1 2  8  32  128  512  2^11 2^13 2^15];
[skinrow,skincol]=find(y==1);
Skin=x(skinrow,:);
[no_skinrow,no_skincol]=find(y==-1);
no_Skin=x(no_skinrow,:);
%-------------------------------------
% Split&Test&Train - Cross Validation
randindex=randperm(size(data,1));
train=randindex(1:floor(Percent*length(randindex)));
test=randindex(floor(Percent*length(randindex))+1:end);
x_train=x(train,:);
x_test=x(test,:);
y_train=y(train);
y_test=y(test);
%-------------------------------------
% Learning - machine learning algorithm
[bestC,errors,w]=Lerning_ML(x_train,y_train,C);
%-------------------------------------
% Error
minindex=min(min(x));
x=x+abs(minindex);
x=x/max(max(x));
minindex=min(min(x_test));
x_test=x_test+abs(minindex);
x_test=x_test/max(max(x_test));
machiney=zeros(1,length(y_test));
k=1;
m=1;
    for j=1:length(y_test)
        x=[x_test(j,:) 1];
        x=x';
        if w*x>0
            machiney(j)=1;
            Skin_by_machine(k,:)=x_test(j,:);
            k=k+1;
        else
            machiney(j)=-1;
            no_Skin_by_machine(m,:)=x_test(j,:);
            m=m+1;
        end
    end
%find the error
    count=0;
 for k=1:length(y_test)
     if y_test(k)==machiney(k)
         count=count+1;
     end
 end
 Error=1-count/length(y_test);
 trueskin=find(y_test==1);
 falseskin=find(y_test==-1);
 trueskin=x_test(trueskin,1:3);
 falseskin=x_test(falseskin,1:3);
 %normalizing
 minindex=min(min(trueskin));
 trueskin=trueskin+abs(minindex);
 trueskin=trueskin/max(max(trueskin));
 minindex=min(min(falseskin));
 falseskin=falseskin+abs(minindex);
 falseskin=falseskin/max(max(falseskin));
 %normalizing feature values
 minindex=min(min(Skin));
 Skin=Skin+abs(minindex);
 Skin=Skin/max(max(Skin));
 minindex=min(min(no_Skin));
 no_Skin=no_Skin+abs(minindex);
 no_Skin=no_Skin/max(max(no_Skin));
 minindex=min(min(Skin_by_machine));
 Skin_by_machine=Skin_by_machine+abs(minindex);
 Skin_by_machine=Skin_by_machine/max(max(Skin_by_machine));
 minindex=min(min(no_Skin_by_machine));
 no_Skin_by_machine=no_Skin_by_machine+abs(minindex);
 no_Skin_by_machine=no_Skin_by_machine/max(max(no_Skin_by_machine));
 %-------------------------------------
 %plot the results
 figure(1)
 scatter3(Skin(:,1),Skin(:,2),Skin(:,3),'g','x')
 hold on
 scatter3(no_Skin(:,1),no_Skin(:,2),no_Skin(:,3),'r','o')
 hold on
 normal = [w(1),w(2),w(3)];
 hold on
 [xx,yy]=meshgrid(0:0.05:1,0:0.05:1);
 z = (-normal(1)*xx - normal(2)*yy - w(4))/normal(3);
 surf(xx,yy,z)
 xlabel('X')
 ylabel('Y')
 zlabel('Z')
 title('classification according data')
 legend('skin','no skin')
 %-----------------
 figure(2)
 scatter3(Skin_by_machine(:,1),Skin_by_machine(:,2),Skin_by_machine(:,3),'g','x')
 hold on
 scatter3(no_Skin_by_machine(:,1),no_Skin_by_machine(:,2),no_Skin_by_machine(:,3),'r','o')
 normal = [w(1),w(2),w(3)];
 hold on
 [xx,yy]=meshgrid(0:0.05:1,0:0.05:1);
 z = (-normal(1)*xx - normal(2)*yy - w(4))/normal(3);
 surf(xx,yy,z)
 xlabel('X')
 ylabel('Y')
 zlabel('Z')
 title('classification by machine learning')
 legend('true skin data','no skin data')
 text(0.3,0.6,['Error= ',num2str(Error*100)]) 
 