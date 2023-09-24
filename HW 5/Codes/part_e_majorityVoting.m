close; clear;clc

disp('--- start ---')

itr = 100;

distr='kernel';
accuracy=zeros(1,itr);
precision=zeros(1,itr);

randn('seed',20)
m1 = rand(100,1)';
mu = [m1 ;m1+0.4*ones(100,1)]';
sqrt(abs(sum((mu(:,1)-mu(:,2)).^2)))
distance = sqrt(abs(sum((mu(:,1)-mu(:,2)).^2)));
Sigma_x = 0.2*eye(100);
Sigma_y = 0.4*eye(100);
points_per_class = [500 500];
X = mvnrnd(mu(:,1),Sigma_x,points_per_class(1))';
X = [X mvnrnd(mu(:,2), Sigma_y, points_per_class(2))'];
y = [ones(1, 350) -ones(1,350)];

for n = 1:1:itr
    g = X(:,1:500);
    data = g';
    cv = cvpartition(size(data,1),'HoldOut',0.3);
    idx = cv.test;
    dataTrain = data(~idx,:);
    dataTest  = data(idx,:);
    
    g1 = X(:,501:1000);
    data1 = g1';
    cv1 = cvpartition(size(data1,1),'HoldOut',0.3);
    idx1 = cv1.test;
    dataTrain1 = data1(~idx1,:);
    dataTest1  = data1(idx1,:);

    trainData = [dataTrain ;dataTrain1];
    trainLable = y';
    testData = [[dataTest ;dataTest1]];
    testLable = [ones(1, 150) -ones(1,150)]';
    [predictedLable_1] = NaiveBayesClassifier(trainData, trainLable, testData, testLable, distr);
    
    [predictedLable_2] = KNN_Classifier(3,trainData, trainLable, testData);
    
    [predictedLable_3] = KNN_Classifier(5,trainData, trainLable, testData);
    
    [predictedLable_4] = SVM_Classifier(trainData, trainLable, testData);
    
    [predictedLable_5] = decisionTreeClassifier(trainData, trainLable, testData);
    predictedLable = sign(predictedLable_1 + predictedLable_2 + predictedLable_3 + predictedLable_4 + predictedLable_5);
    accuracy(n) = sum(predictedLable==testLable)/length(predictedLable);
    precision(n) = sum(predictedLable(1:150)==1)/sum(predictedLable==1);
end
str = {'Majority Voting'};

figure()
ax = axes;
plot(1:1:itr,100.*accuracy,'LineWidth',3)
title('Accuracy Curve Of Majority Voting Based on Iterations')
xlabel('ITERATION','fontweight','bold','fontsize',10);
ylabel('ACCURACY (%)','fontweight','bold','fontsize',10);
set(ax, 'YTick', [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100], 'YLim', [0, 100]);
ytickformat(ax, 'percentage');
legend(str)
figure()
ax = axes;
plot(1:1:itr,100.*precision,'LineWidth',3)
title('Precision Curve Of Majority Voting Based on Iterations');
xlabel('ITERATION','fontweight','bold','fontsize',10);
ylabel('PRECISION (%)','fontweight','bold','fontsize',10);
set(ax, 'YTick', [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100], 'YLim', [0, 100]);
ytickformat(ax, 'percentage');
legend(str)

average_accuracy_of_accuracy = mean(accuracy);
standard_deviation_of_accuracy = std(accuracy);
average_accuracy_of_precision = mean(precision);
standard_deviation_of_precision = std(precision);

