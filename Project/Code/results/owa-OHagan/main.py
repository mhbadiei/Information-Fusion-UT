# author : Abbas Badiei

import collections
import glob
from prettytable import PrettyTable
from Document import *
import matplotlib.pyplot as plt
import statistics 

class NLP:
    def __init__(self):
        self.test_classes = {}
        self.classes = {}
        self.data = collections.OrderedDict()
        self.accuracy = 0

    def get_data(self, path):
        for fileName in glob.glob(path + '/*'):
            temp = {0: str(fileName.split("\\")[1]).split("_")[0]}
            # print(str(fileName.split("\\")[1]).split("_")[0])
            if temp[0] not in self.classes:
                self.classes[temp[0]] = DocumentClassification(temp[0])
            with open(fileName, encoding="utf8") as f:
                for line in f:
                    temp[1] = line
                    self.classes.get(temp[0]).documents.append(Document(temp[0], temp[1]))

    def train(self, path):
        self.get_data(path)  # Fetch data
        self.calculating_probabilities()  # Creat word bag
        self.calculate_class_probability()  # Assign probability of each class

    def calculating_probabilities(self):
        for i in self.classes.values():
            i.calculate_unary_probabilities()
            i.calculate_binary_probabilities()
            i.binary_back_off()

    def calculate_class_probability(self):
        total_docs = sum([len(i.documents) for i in self.classes.values()])
        for i in self.classes.values():
            # print(len(i.documents))
            i.p = len(i.documents) / total_docs

    def assign_class(self, doc, mode):
        result = {}
        if mode == 'U':
            for key, value in self.classes.items():
                result[key] = value.get_unary_probability(doc)
        elif mode == 'B':
            for key, value in self.classes.items():
                result[key] = value.get_binary_probability(doc)
        elif mode == 'S':
            for key, value in self.classes.items():
                result[key] = value.get_binary_back_off_probability(doc)
        else:
            raise Exception("Not a valid mode")
        m = max(result.values())
        for key, value in result.items():
            if value == m:
                return key

    def get_test_data(self, path):
        self.test_classes = {}
        for fileName in glob.glob(path):
            with open(fileName, encoding="utf8") as f:
                for line in f:
                    temp = line.split('\t')
                    # print(temp[0])
                    if temp[0] == '1':
                        temp[0] = 'ferdowsi'
                    if temp[0] == '2':
                        temp[0] = 'hafez'
                    if temp[0] == '3':
                        temp[0] = 'molavi'
                    if temp[0] not in self.test_classes:
                        self.test_classes[temp[0]] = DocumentClassification(temp[0])
                    self.test_classes.get(temp[0]).documents.append(Document(temp[0], temp[1]))

    def predict(self, mode, path):
        count = 0
        total_count = 0
        self.get_test_data(path)
        for i in self.test_classes.keys():
            # print(i)
            self.data[i] = collections.OrderedDict()
            self.data[i] = {k: 0 for k in self.test_classes.keys()}
        itr = 0
        for key, value in self.test_classes.items():
            for doc in value.documents:
                itr +=1
                status = self.assign_class(doc, mode)
                self.data[key][status] = self.data.get(key).get(status) + 1
                #print(itr, key, status)
                if status == key:
                    count += 1
                total_count += 1
        #print(count ,total_count)
        self.accuracy = count / total_count;
        print("Accuracy of program detection : ", count / total_count)

    def unary_predict(self, path):
        self.predict('U', path)
        return self.accuracy

    def binary_predict(self, path):
        self.predict('B', path)
        return self.accuracy

    def binary_back_off_predict(self, path):
        self.predict('S', path)
        return self.accuracy

    def print_table(self):
        """ Printing the result as a table """
        t = PrettyTable([""] + [i for i in self.test_classes.keys()])

        for key, value in self.data.items():
            t.add_row([key, ] + [v for v in value.values()])
        print(t)
        print("\n")


if __name__ == "__main__":
    accuracy = list()
        
    for i in range(10):
        model = NLP()  # Initiating the model
        model.train('train_set')
        file_name = 'test_file' + str(i+1) +'.txt'
        print(file_name)
        accuracy.append(100*model.binary_back_off_predict('test_set/' + file_name))
        model.print_table()
    #print(accuracy)
    plt.figure()
    plt.plot([x+1 for x in range(10)] ,accuracy,'-')
    plt.xlabel("Iteration")
    plt.ylabel("Accuracy (%)")  
    plt.ylim((50,100))
    plt.title('back off model with O’Hagan’s OWA')
    average_accuracy = sum(accuracy)/len(accuracy)
    standard_deviation = statistics.stdev(accuracy)
    print("average accuracy", average_accuracy)
    print("standard deviation", standard_deviation)
    plt.legend()
    plt.show()

