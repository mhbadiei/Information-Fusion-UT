close; clear;clc

disp('--- start ---')

itr = 100;

distr='kernel';
accuracy=zeros(5,itr);
precision=zeros(5,itr);
average_accuracy_of_accuracy = zeros(5,1);
standard_deviation_of_accuracy = zeros(5,1);
average_accuracy_of_precision = zeros(5,1);
standard_deviation_of_precision = zeros(5,1);

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
    [predictedLable] = NaiveBayesClassifier(trainData, trainLable, testData, testLable, distr);
    accuracy(1,n) = sum(predictedLable==testLable)/length(predictedLable);
    precision(1,n) = sum(predictedLable(1:150)==1)/sum(predictedLable==1);
    
    [predictedLable] = KNN_Classifier(3,trainData, trainLable, testData);
    accuracy(2,n) = sum(predictedLable==testLable)/length(predictedLable);
    precision(2,n) = sum(predictedLable(1:150)==1)/sum(predictedLable==1);
    
    [predictedLable] = KNN_Classifier(5,trainData, trainLable, testData);
    accuracy(3,n) = sum(predictedLable==testLable)/length(predictedLable);
    precision(3,n) = sum(predictedLable(1:150)==1)/sum(predictedLable==1);
    
    [predictedLable] = SVM_Classifier(trainData, trainLable, testData);
    accuracy(4,n) = sum(predictedLable==testLable)/length(predictedLable);
    precision(4,n) = sum(predictedLable(1:150)==1)/sum(predictedLable==1);
    
    [predictedLable] = decisionTreeClassifier(trainData, trainLable, testData);
    accuracy(5,n) = sum(predictedLable==testLable)/length(predictedLable);
    precision(5,n) = sum(predictedLable(1:150)==1)/sum(predictedLable==1);
end
str = {'Naive Bayes', 'KNN K=3', 'KNN K=5', 'SVM','Decision Tree'};
for i=1:1:5
    figure()
    ax = axes;
    plot(1:1:itr,100.*accuracy(i,:),'LineWidth',3)
    title('Accuracy Curve Based on Iterations')
    xlabel('ITERATION','fontweight','bold','fontsize',10);
    ylabel('ACCURACY (%)','fontweight','bold','fontsize',10);
    set(ax, 'YTick', [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100], 'YLim', [0, 100]);
    ytickformat(ax, 'percentage');
    legend(str{i})
    figure()
    ax = axes;
    plot(1:1:itr,100.*precision(i,:),'LineWidth',3)
    title('Precision Curve Based on Iterations');
    xlabel('ITERATION','fontweight','bold','fontsize',10);
    ylabel('PRECISION (%)','fontweight','bold','fontsize',10);
    set(ax, 'YTick', [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100], 'YLim', [0, 100]);
    ytickformat(ax, 'percentage');
    legend(str{i})
    
    average_accuracy_of_accuracy(i,1) = mean(accuracy(i,:));
    standard_deviation_of_accuracy(i,1) = std(accuracy(i,:));
    average_accuracy_of_precision(i,1) = mean(precision(i,:));
    standard_deviation_of_precision(i,1) = std(precision(i,:));
end
