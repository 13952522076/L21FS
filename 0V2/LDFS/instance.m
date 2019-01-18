function [ Data ] = instance( B,feaNum,randSeed,outratio )
%B:        the input data, including label+data
%feaNum:   selected features number
%randSeed: random seed
    %% if print out 
    output=1;
    dim = length(unique(B(:,1)))-1;
    %% gui yi hua 
    A=B(1:end,2:end); % A is the input data
    Max=max(max(A));
    Min=min(min(A));
    A=2*(A-Min)./(Max-Min)-1; 
    %%
    d=B(1:end,1); % d is the labels
    trainCorr=0;
    testCorr=0;
    [sm sn]=size(A);
    accuIter = 0;
    cpu_time = 0;
    
    %% random the order
    rand('state',randSeed);
    r=randperm(size(d,1));
    d=d(r,:);
    A=A(r,:); 
    
    %% cross validation
    k=5;
    indx = [0:k];indx = floor(sm*indx/k);
    for i = 1:k
      
        Ctest = []; dtest = [];Ctrain = []; dtrain = [];
        Ctest  = A((indx(i)+1:indx(i+1)),:);
        dtest  = d(indx(i)+1:indx(i+1));
        Ctrain = A(1:indx(i),:);
        Ctrain = [Ctrain;A(indx(i+1)+1:sm,:)];
        dtrain = [d(1:indx(i));d(indx(i+1)+1:sm,:)];
        
        if outratio > 0
            %make noise
            [ dtrain,Ctrain ] = make_noise( dtrain,Ctrain,outratio);
        end
        
        % compute and time
        tic
        %[ W ] = svc(Ctrain);
        [W,index] = LDFS(dtrain,Ctrain,dim,1);
        thistoc(i,1)=toc;
        [ Accuracy ] = svcerror( W,Ctrain,dtrain,Ctest,dtest,feaNum );
        tmpTestCorr(i,1)=Accuracy;
        
    end
    
    
    %% output
    testCorr = sum(tmpTestCorr)/k;
    cpu_time=sum(thistoc)/k;
    testcorrstd=std(tmpTestCorr,1);
    if output==1
        fprintf(1,'==============================================');
        fprintf(1,'\nTesting set correctness: %3.2f%',testCorr/100);
        fprintf(1,'\nAverage cpu_time: %10.4f',cpu_time);
        fprintf(1,'\nTest corrstd: %3.4f\n',testcorrstd);
    end
    
    Data.tmpTestCorr=tmpTestCorr;
    Data.thistoc=thistoc;
    
    Data.avg.trainCorr=trainCorr;
    Data.avg.testCorr=testCorr;
    Data.avg.cpu_time=cpu_time;
    Data.avg.testcorrstd=testcorrstd;
 

end

