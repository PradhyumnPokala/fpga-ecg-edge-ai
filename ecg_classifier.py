import pandas as pd
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score, classification_report
from sklearn.tree import export_text
from sklearn.utils import resample

# Load data
print("Loading data...")
train = pd.read_csv('mitbih_train.csv', header=None)
test  = pd.read_csv('mitbih_test.csv',  header=None)
print("Done!")

# Split features and labels
X_train = train.iloc[:, :187].values
y_train = train.iloc[:, 187].values.astype(int)
X_test  = test.iloc[:, :187].values
y_test  = test.iloc[:, 187].values.astype(int)

# Fix class imbalance - resample all classes to 5000
print("Balancing classes...")
train_df = train.copy()
balanced_frames = []
for cls in range(5):
    cls_data = train_df[train_df.iloc[:, 187].astype(int) == cls]
    cls_resampled = resample(cls_data, replace=True, n_samples=5000, random_state=42)
    balanced_frames.append(cls_resampled)

train_balanced = pd.concat(balanced_frames).sample(frac=1, random_state=42).reset_index(drop=True)
X_train_bal = train_balanced.iloc[:, :187].values
y_train_bal = train_balanced.iloc[:, 187].values.astype(int)

print("Balanced class distribution:")
print(pd.Series(y_train_bal).value_counts().sort_index())

# Train Decision Tree
print("\nTraining Decision Tree (max_depth=5)...")
clf = DecisionTreeClassifier(max_depth=5, random_state=42)
clf.fit(X_train_bal, y_train_bal)

# Evaluate
y_pred = clf.predict(X_test)
acc = accuracy_score(y_test, y_pred)
print(f"\nAccuracy: {acc * 100:.2f}%")
print(classification_report(y_test, y_pred))

# Export tree rules for Verilog conversion
tree_rules = export_text(clf, max_depth=5)
print("\nDecision Tree Rules:")
print(tree_rules)

with open("tree_rules.txt", "w") as f:
    f.write(tree_rules)
print("Tree rules saved to tree_rules.txt")