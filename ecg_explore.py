import pandas as pd
import matplotlib.pyplot as plt

print("Loading data...")
train = pd.read_csv('mitbih_train.csv', header=None)
print("Done!")

print("Shape:", train.shape)
print("Classes:", train[187].value_counts())

# Plot one ECG sample
plt.plot(train.iloc[0, :187])
plt.title('ECG Sample - Class: ' + str(train.iloc[0, 187]))
plt.xlabel('Time steps')
plt.ylabel('Amplitude')
plt.show()