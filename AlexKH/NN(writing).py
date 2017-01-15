import numpy as np
from sklearn import preprocessing
from keras.models import Sequential
from keras.layers import Dense
import pandas as pd


def baseline_model():
    model = Sequential()
    model.add(Dense(32, input_dim=4, init='uniform', activation='relu'))
    model.add(Dense(16, init='uniform', activation='relu'))
    model.add(Dense(1, init='uniform', activation='sigmoid'))

    # Compile model     #logarithmic  loss     #method
    model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
    return model

def main():
    # data reading
    df = pd.read_csv('data/transfusion.data.txt')
    df.columns = ['Months since Last Donation', 'Number of Donations', 'Total Volume Donated (c.c.)',
                  'Months since First Donation', 'Made Donation in March 2007']

    # new feature
    Ratio = df['Months since Last Donation']/df['Months since First Donation']
    df['Ratio'] = Ratio

    # useless feature
    df = df.drop(['Total Volume Donated (c.c.)'], 1)

    # data for model
    X = np.array(df.drop(['Made Donation in March 2007'], 1))
    y = np.array(df['Made Donation in March 2007'])

    # data scaling
    X = preprocessing.scale(X)

    # Fit the model
    clf = baseline_model()
    clf.fit(X, y, nb_epoch=12000, batch_size=10)

    # evaluate the model
    testdf = pd.read_csv('data/test.csv')
    testdf.columns = ['Id', 'Months since Last Donation', 'Number of Donations',
                      'Total Volume Donated (c.c.)', 'Months since First Donation']

    testdf['Ratio'] = testdf['Months since Last Donation']/testdf['Months since First Donation']

    testdf = testdf.drop(['Total Volume Donated (c.c.)'], 1)

    Xtest = preprocessing.scale(np.array(testdf.drop(['Id'], 1)))

    Id = testdf['Id'].tolist()
    predicted = [i[0] for i in clf.predict_proba(Xtest)]

    pd.DataFrame({'': Id,
                  'Made Donation in March 2007': predicted})\
        .to_csv("result/resultNN.csv", sep=',', index=False)

if __name__ == "__main__":
    main()
