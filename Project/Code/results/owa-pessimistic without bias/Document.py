import math
from itertools import tee


class DocumentClassification:
    def __init__(self, category):
        self.category = category
        self.documents = []
        self.unary_probabilities = {}
        self.frequency = {}
        self.binary_probabilities = {}
        self.binary_probabilities_backed_off = {}
        self.p = None

    def calculate_unary_probabilities(self):
        frequency, total_count = self.get_word_frequency()
        self.unary_probabilities = {k: v/total_count for k, v in frequency.items()}

    def get_word_frequency(self):
        words_frequency = {'UNK': 0}
        for i in self.documents:
            for j in i.word_list:
                if j not in words_frequency.keys():
                    words_frequency['UNK'] = words_frequency.get('UNK') + 1
                    words_frequency[j] = 1
                else:
                    words_frequency[j] = words_frequency.get(j) + 1
        total_count = sum([v for v in words_frequency.values()])
        self.frequency = words_frequency
        return [words_frequency, total_count]

    def calculate_binary_probabilities(self):
        pair_wise_words_frequency = {}

        for i in self.documents:
            for j, k in self.pair_wise(i.word_list):
                # print(j, k)
                if f"{j} {k}" in pair_wise_words_frequency:
                    pair_wise_words_frequency[f"{j} {k}"] = pair_wise_words_frequency.get(f"{j} {k}") + 1
                else:
                    pair_wise_words_frequency[f"{j} {k}"] = 1
        for key, value in pair_wise_words_frequency.items():
            self.binary_probabilities[key] = value/self.frequency.get(key.split()[0])

    @staticmethod
    def pair_wise(word_list):
        a, b = tee(word_list, 2)
        next(b, None)
        return zip(a, b)

    def binary_back_off(self):

        for key, value in self.binary_probabilities.items():
            if (self.unary_probabilities.get(key.split()[1])) >= value:
                w1 = 0.36
                w2 = 0.64
            else:
                w1 = 0.36
                w2 = 0.64
            self.binary_probabilities_backed_off[key] = \
                (w1 * self.unary_probabilities.get(key.split()[1])) + (w2 * value)

    def get_unary_probability(self, doc):
        result = 1
        for i in doc.word_list:
            p = self.unary_probabilities.get(i)
            result += math.log10(p) if p is not None else math.log10(0.00000001)
        return result + math.log10(self.p)

    def get_binary_probability(self, doc):
        result = 1
        for i, j in self.pair_wise(doc.word_list):
            temp = self.binary_probabilities.get(f"{i} {j}")
            result += math.log10(temp) if temp is not None else math.log10(0.00000001)
        return result + math.log10(self.p)

    def get_binary_back_off_probability(self, doc):
        result = 1
        for i, j in self.pair_wise(doc.word_list):
            temp = self.binary_probabilities_backed_off.get(f"{i} {j}")
            result += math.log10(temp) if temp is not None else math.log10(0.00000001)
        return result + math.log10(self.p)


class Document:
    def __init__(self, document_class, content):
        self.document_class = document_class
        self.word_list = content.split()
        self.word_frequency = self.get_frequency()
        self.content = content

    def get_frequency(self):
        result = {}
        for i in set(self.word_list):
            result[i] = self.word_list.count(i)
        return result
