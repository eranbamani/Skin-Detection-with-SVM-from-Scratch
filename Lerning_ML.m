%ERAN BAMANI
%23.12.18
%ML Algorithm
%Lerning fun
%===============================================
function [bestC,Errors,w]=Lerning_ML(x_train,y_train,C)
Cbestvector=zeros(1,length(C));
Epoch_Times=3;
NUM=5;
Percent=0.7;
%normalizing mat
minindex=min(min(x_train));
x_train=x_train+abs(minindex);
x_train=x_train/max(max(x_train));
for i=1:length(C)
    errors=zeros(1,NUM);
    for j=1:NUM
        randindex=randperm(size(x_train,1));
        train=randindex(1:floor(Percent*length(randindex)));
        test=randindex(floor(Percent*length(randindex))+1:end);
        Train=x_train(train,1:3);
        Test=x_train(test,1:3);
        yTrain=y_train(train);
        yTest=y_train(test);
       
        w=SGD(Train,yTrain,C(i),Epoch_Times);
    machiney=zeros(1,length(yTest));
    for n=1:length(test)
        x=[Test(n,:) 1];%run along only test data
        x=x';
        if w*x>=0
            machiney(n)=1;
        else
            machiney(n)=-1;
        end
    end
%find the error
    count=0;
 for k=1:length(yTest)
     if yTest(k)==machiney(k)
         count=count+1;
     end
 end
 Error=1-count/length(yTest);
 errors(j)=Error;
    end
    Cbestvector(i)=mean(errors);
end
    minError=min(Cbestvector);
    Cindex=find(Cbestvector==minError);
    bestC=C(Cindex);
    Errors=Cbestvector;
    w=SGD(x_train,y_train,bestC,Epoch_Times);%%we got optimized C and optimized w