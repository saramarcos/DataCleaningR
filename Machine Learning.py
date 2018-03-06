
import pandas as pd
import numpy as np
from sklearn.linear_model import LogisticRegression
import sklearn.metrics
import matplotlib.pyplot as plt
import re
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn import preprocessing
from sklearn.neural_network import MLPClassifier
from sklearn.svm import SVC
from sklearn.svm import NuSVC
from sklearn.mixture import GaussianMixture

#%% Voluntary Turnover Prediction

# Importing and renaming datasets

Master = pd.read_csv('C:/Personal/71069232/Documents/PepsiCo/Machine Learning/Turnover Prediction/2016 Modeling/Global L8+ 2012-2014_Vol Turn.csv', na_values = [' ']) # Cannot use regex?

Master.columns = Master.columns.str.lower()

colNames = list(Master.columns.values)

# Global L8+ Models
# Master[['status', 'emplid']].groupby('status').agg(lambda x: len(x))

indVars = """Year_2012 Year_2013  /*Year_2014*/  
/*wkcountry_US*/ wkcountry_Canada wkcountry_Mexico wkcountry_Russia wkcountry_UK  wkcountry_India  wkcountry_China  wkcountry_Brazil  wkcountry_Egypt wkcountry_Spain 
wkcountry_UAE wkcountry_Australia wkcountry_Ireland wkcountry_Thailand wkcountry_Colombia wkcountry_Turkey wkcountry_Argentina wkcountry_Venezuela wkcountry_Poland 
wkcountry_France wkcountry_SaudiArabia wkcountry_Ukraine wkcountry_SouthAfrica wkcountry_Netherlands wkcountry_Switzerland wkcountry_othergll8
age gender_female 
tenservice tenband  Expat
 supervisor /*bandlevel_L8*/ bandlevel_L9 bandlevel_L10 bandlevel_L11 bandlevel_B1 bandlevel_B2 bandlevel_B3 bandlevel_B4 bandlevel_B5
HighPotential_CurYr /*KeyContributor_CurYr*/ CriticalProfessional_CurYr  PerformanceConcern_CurYr  Potential_CurYr_MISS 
Pay_BdRatio_CompaRatio   /*BonusTotal_AtTarget*/  PayChangeBasePCT PayChangeBasePCT_miss
lateral_division lateral_function newhire  Global_grp  
 function_BIS function_Sales function_Communications function_Finance function_Franchise function_GM function_HR function_Insights function_Legal function_Marketing 
function_Procurement function_RND /*function_SupplyChain_Ops*/
supSOC SupAge_DiffEE  Suptenservice SupChg
Suptscore SupTscore_miss  
grpvolturn GrpTenure_Mean
Chg_fromHiPo   
LowPerformer_CurYr /*AveragePerformer_CurYr*/ HighPerformer_CurYr_GE7 TCIndex_CurYr_MISS"""


indVars = indVars.lower()
indVars = re.sub("\\n+", " ", indVars)
indVars = re.sub("/\\*[^*]*\\*/", " ", indVars)
indVars = re.sub("^\\s+|\\s+$", "", indVars)
indVars = re.sub("\\s+", " ", indVars)
indVars = indVars.split(" ")

# all([_ in colNames for _ in indVars])
# set(indVars).issubset(set(colNames))

ModelData = Master[indVars + ['term_vol_lead1']]
ModelData = ModelData.dropna(how = 'any')

X = ModelData[indVars]
y = ModelData.term_vol_lead1

# Normalize the variables to the same scale
X_scaled = pd.DataFrame(preprocessing.scale(X), columns = X.columns.values)

# Split the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.3, random_state=42)


# sum(X.isnull().values.ravel())

# X.dtypes.to_clipboard()

# Logistic Regression

lrc = LogisticRegression(C = 1000000)

lrc.fit(X_train, y_train)

lrc.score(X_train, y_train)

prob_pred_LR_train = lrc.predict_proba(X_train)[:, 1]
prob_pred_LR_test = lrc.predict_proba(X_test)[:, 1]

precision_LR_train, recall_LR_train, thresholds_LR_train_PR = sklearn.metrics.precision_recall_curve(y_train, prob_pred_LR_train)
precision_LR_test, recall_LR_test, thresholds_LR_test_PR = sklearn.metrics.precision_recall_curve(y_test, prob_pred_LR_test)

fpr_LR_train, tpr_LR_train, thresholds_LR_train_ROC = sklearn.metrics.roc_curve(y_train, prob_pred_LR_train)
fpr_LR_test, tpr_LR_test, thresholds_LR_test_ROC = sklearn.metrics.roc_curve(y_test, prob_pred_LR_test)

thresholds_LR_train_PR = np.insert(thresholds_LR_train_PR, 0, 0)
thresholds_LR_test_PR = np.insert(thresholds_LR_test_PR, 0, 0)

#GlobalL8p_Result.score(X, y)
#
#y_prob = pd.DataFrame(GlobalL8p_Result.predict_proba(X))
#
#Classification = pd.DataFrame(data = {'vol_term_lead1': y, 'predicted_vol_term_probability': y_prob[1]})
#
#Classification['y_pred'] = Classification['predicted_vol_term_probability'].map(lambda x: int(x > 0.1))
#
#pd.crosstab(Classification.vol_term_lead1, Classification.y_pred, colnames = ['y_pred'])
#

# Coefficient
# pd.DataFrame(zip(X.columns, np.transpose(GlobalL8p_Result.coef_))).to_clipboard()


# Random Forest

rfc = RandomForestClassifier(n_estimators = 100, max_features = 'auto', min_samples_split = 20, max_depth = 5, n_jobs = 4, oob_score = True)
rfc.fit(X_train, y_train)

rfc.score(X_train, y_train)


plt.bar(range(X_train.shape[1]), rfc.feature_importances_)
plt.show()
X.columns.values
feature_ranking = pd.DataFrame({'feature': X.columns.values, 'importance': rfc.feature_importances_})
feature_ranking.to_clipboard()


prob_pred_RF_train = rfc.predict_proba(X_train)[:, 1]
prob_pred_RF_test = rfc.predict_proba(X_test)[:, 1]

precision_RF_train, recall_RF_train, thresholds_RF_train_PR = sklearn.metrics.precision_recall_curve(y_train, prob_pred_RF_train)
precision_RF_test, recall_RF_test, thresholds_RF_test_PR = sklearn.metrics.precision_recall_curve(y_test, prob_pred_RF_test)

fpr_RF_train, tpr_RF_train, thresholds_RF_train_ROC = sklearn.metrics.roc_curve(y_train, prob_pred_RF_train)
fpr_RF_test, tpr_RF_test, thresholds_RF_test_ROC = sklearn.metrics.roc_curve(y_test, prob_pred_RF_test)

thresholds_RF_train_PR = np.insert(thresholds_RF_train_PR, 0, 0)
thresholds_RF_test_PR = np.insert(thresholds_RF_test_PR, 0, 0)


plt.clf()
plt.plot(fpr_RF_train, tpr_RF_train, label = 'tpr_RF_train vs. fpr_RF_train', linewidth = 2.0)
plt.plot(fpr_RF_test, tpr_RF_test, label = 'tpr_RF_test vs. fpr_RF_test', linewidth = 2.0)
plt.plot(fpr_LR_train, tpr_LR_train, linestyle = '--', label = 'tpr_LR_train vs. fpr_LR_train')
plt.plot(fpr_LR_test, tpr_LR_test, linestyle = '--', label = 'tpr_LR_test vs. fpr_LR_test')
plt.plot([0, 1], [0, 1], linestyle = '-.', label = 'Random Guess')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1), fontsize = 18)
plt.show()




# Multi-layer Perceptron

mlpc = MLPClassifier(hidden_layer_sizes = (20,), activation = 'logistic', alpha = 0.05)
mlpc.fit(X_train, y_train)

prob_pred_NN_train = mlpc.predict_proba(X_train)[:, 1]
prob_pred_NN_test = mlpc.predict_proba(X_test)[:, 1]

precision_NN_train, recall_NN_train, thresholds_NN_train_PR = sklearn.metrics.precision_recall_curve(y_train, prob_pred_NN_train)
precision_NN_test, recall_NN_test, thresholds_NN_test_PR = sklearn.metrics.precision_recall_curve(y_test, prob_pred_NN_test)

fpr_NN_train, tpr_NN_train, thresholds_NN_train_ROC = sklearn.metrics.roc_curve(y_train, prob_pred_NN_train)
fpr_NN_test, tpr_NN_test, thresholds_NN_test_ROC = sklearn.metrics.roc_curve(y_test, prob_pred_NN_test)

thresholds_NN_train_PR = np.insert(thresholds_NN_train_PR, 0, 0)
thresholds_NN_test_PR = np.insert(thresholds_NN_test_PR, 0, 0)


plt.clf()
plt.plot(fpr_NN_train, tpr_NN_train, label = 'tpr_NN_train vs. fpr_NN_train', linewidth = 2.0)
plt.plot(fpr_NN_test, tpr_NN_test, label = 'tpr_NN_test vs. fpr_NN_test', linewidth = 2.0)
plt.plot(fpr_LR_train, tpr_LR_train, linestyle = '--', label = 'tpr_LR_train vs. fpr_LR_train')
plt.plot(fpr_LR_test, tpr_LR_test, linestyle = '--', label = 'tpr_LR_test vs. fpr_LR_test')
plt.plot([0, 1], [0, 1], linestyle = '-.', label = 'Random Guess')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1), fontsize = 18)
plt.show()


# Support Vector Classification
#for const in np.linspace(1e-5, 1e-2, num = 10):
#    for gammaVal in np.linspace(1e-2, 1e1, num = 20):
svc = SVC(C = 0.001, probability = True, gamma = 0.006, kernel = 'rbf', cache_size = 10000)
svc.fit(X_train, y_train)
svc.score(X_train, y_train)

prob_pred_SV_train = svc.predict_proba(X_train)[:, 1]
prob_pred_SV_test = svc.predict_proba(X_test)[:, 1]

precision_SV_train, recall_SV_train, thresholds_SV_train_PR = sklearn.metrics.precision_recall_curve(y_train, prob_pred_SV_train)
precision_SV_test, recall_SV_test, thresholds_SV_test_PR = sklearn.metrics.precision_recall_curve(y_test, prob_pred_SV_test)

fpr_SV_train, tpr_SV_train, thresholds_SV_train_ROC = sklearn.metrics.roc_curve(y_train, prob_pred_SV_train)
fpr_SV_test, tpr_SV_test, thresholds_SV_test_ROC = sklearn.metrics.roc_curve(y_test, prob_pred_SV_test)

thresholds_SV_train_PR = np.insert(thresholds_SV_train_PR, 0, 0)
thresholds_SV_test_PR = np.insert(thresholds_SV_test_PR, 0, 0)
        
#print const, gammaVal
        

plt.clf()
plt.plot(fpr_SV_train, tpr_SV_train, label = 'tpr_SV_train vs. fpr_SV_train', linewidth = 2.0)
plt.plot(fpr_SV_test, tpr_SV_test, label = 'tpr_SV_test vs. fpr_SV_test', linewidth = 2.0)
plt.plot(fpr_LR_train, tpr_LR_train, linestyle = '--', label = 'tpr_LR_train vs. fpr_LR_train')
plt.plot(fpr_LR_test, tpr_LR_test, linestyle = '--', label = 'tpr_LR_test vs. fpr_LR_test')
plt.plot([0, 1], [0, 1], linestyle = '-.', label = 'Random Guess')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1), fontsize = 18)
plt.show()



# Anomaly Detection

gmc = GaussianMixture(n_components = 76)
X_train_2 = X_train[list(y_train == 0)]
gmc.fit(X_train_2)

prob_pred_GM_train = np.exp(gmc.score_samples(X_train))
prob_pred_GM_test = np.exp(gmc.score_samples(X_test))

precision_GM_train, recall_GM_train, thresholds_GM_train_PR = sklearn.metrics.precision_recall_curve(y_train, prob_pred_GM_train)
precision_GM_test, recall_GM_test, thresholds_GM_test_PR = sklearn.metrics.precision_recall_curve(y_test, prob_pred_GM_test)

fpr_GM_train, tpr_GM_train, thresholds_GM_train_ROC = sklearn.metrics.roc_curve(y_train, prob_pred_GM_train)
fpr_GM_test, tpr_GM_test, thresholds_GM_test_ROC = sklearn.metrics.roc_curve(y_test, prob_pred_GM_test)

thresholds_GM_train_PR = np.insert(thresholds_GM_train_PR, 0, 0)
thresholds_GM_test_PR = np.insert(thresholds_GM_test_PR, 0, 0)


plt.clf()
plt.plot(fpr_GM_train, tpr_GM_train, label = 'tpr_GM_train vs. fpr_GM_train', linewidth = 2.0)
plt.plot(fpr_GM_test, tpr_GM_test, label = 'tpr_GM_test vs. fpr_GM_test', linewidth = 2.0)
plt.plot(fpr_LR_train, tpr_LR_train, linestyle = '--', label = 'tpr_LR_train vs. fpr_LR_train')
plt.plot(fpr_LR_test, tpr_LR_test, linestyle = '--', label = 'tpr_LR_test vs. fpr_LR_test')
plt.plot([0, 1], [0, 1], linestyle = '-.', label = 'Random Guess')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1), fontsize = 18)
plt.show()


prob_pred_MAX_train = pd.DataFrame(zip(prob_pred_LR_train, prob_pred_RF_train, prob_pred_NN_train)).max(axis = 1)
fpr_MAX_train, tpr_MAX_train, thresholds_MAX_train_ROC = sklearn.metrics.roc_curve(y_train, prob_pred_MAX_train)


prob_pred_MAX_test = pd.DataFrame(zip(prob_pred_LR_test, prob_pred_RF_test, prob_pred_NN_test)).max(axis = 1)
fpr_MAX_test, tpr_MAX_test, thresholds_MAX_test_ROC = sklearn.metrics.roc_curve(y_test, prob_pred_MAX_test)



plt.clf()
plt.plot(fpr_MAX_train, tpr_MAX_train, label = 'tpr_MAX_train vs. fpr_MAX_train', linewidth = 2.0)
plt.plot(fpr_MAX_test, tpr_MAX_test, label = 'tpr_MAX_test vs. fpr_MAX_test', linewidth = 2.0)
plt.plot(fpr_LR_train, tpr_LR_train, linestyle = '--', label = 'tpr_LR_train vs. fpr_LR_train')
plt.plot(fpr_LR_test, tpr_LR_test, linestyle = '--', label = 'tpr_LR_test vs. fpr_LR_test')
plt.plot([0, 1], [0, 1], linestyle = '-.', label = 'Random Guess')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1), fontsize = 18)
plt.show()




# Plot Results

plt.clf()
#plt.plot(thresholds_GM_train_PR, precision_GM_train, label = 'precision_GM_train-Threshold')
#plt.plot(thresholds_GM_train_PR, recall_GM_train, label = 'recall_GM_train-Threshold')
#plt.plot(thresholds_GM_test_PR, precision_GM_test, label = 'precision_GM_test-Threshold')
#plt.plot(thresholds_GM_test_PR, recall_GM_test, label = 'recall_GM_test-Threshold')
plt.plot(thresholds_SV_train_PR, precision_SV_train, label = 'precision_SV_train-Threshold')
plt.plot(thresholds_SV_train_PR, recall_SV_train, label = 'recall_SV_train-Threshold')
plt.plot(thresholds_SV_test_PR, precision_SV_test, label = 'precision_SV_test-Threshold')
plt.plot(thresholds_SV_test_PR, recall_SV_test, label = 'recall_SV_test-Threshold')
#plt.plot(thresholds_NN_train_PR, precision_NN_train, label = 'precision_NN_train-Threshold')
#plt.plot(thresholds_NN_train_PR, recall_NN_train, label = 'recall_NN_train-Threshold')
#plt.plot(thresholds_NN_test_PR, precision_NN_test, label = 'precision_NN_test-Threshold')
#plt.plot(thresholds_NN_test_PR, recall_NN_test, label = 'recall_NN_test-Threshold')
#plt.plot(thresholds_RF_train_PR, precision_RF_train, label = 'precision_RF_train-Threshold')
#plt.plot(thresholds_RF_train_PR, recall_RF_train, label = 'recall_RF_train-Threshold')
#plt.plot(thresholds_RF_test_PR, precision_RF_test, label = 'precision_RF_test-Threshold')
#plt.plot(thresholds_RF_test_PR, recall_RF_test, label = 'recall_RF_test-Threshold')
plt.plot(thresholds_LR_train_PR, precision_LR_train, linestyle = '--', label = 'precision_LR_train-Threshold')
plt.plot(thresholds_LR_train_PR, recall_LR_train, linestyle = '--', label = 'recall_LR_train-Threshold')
plt.plot(thresholds_LR_test_PR, precision_LR_test, linestyle = '--', label = 'precision_LR_test-Threshold')
plt.plot(thresholds_LR_test_PR, recall_LR_test, linestyle = '--', label = 'recall_LR_test-Threshold')
plt.title('recall-precision-Threshold')
plt.xlabel('Threshold')
plt.ylabel('recall_RF/precision_RF')
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1))
plt.show()

plt.clf()
#plt.plot(precision_GM_train, recall_GM_train, label = 'recall_GM_train-precision_GM_train')
#plt.plot(precision_GM_test, recall_GM_test, label = 'recall_GM_test-precision_GM_test')
plt.plot(precision_SV_train, recall_SV_train, label = 'recall_SV_train-precision_SV_train')
plt.plot(precision_SV_test, recall_SV_test, label = 'recall_SV_test-precision_SV_test')
#plt.plot(precision_NN_train, recall_NN_train, label = 'recall_NN_train-precision_NN_train')
#plt.plot(precision_NN_test, recall_NN_test, label = 'recall_NN_test-precision_NN_test')
#plt.plot(precision_RF_train, recall_RF_train, label = 'recall_RF_train-precision_RF_train')
#plt.plot(precision_RF_test, recall_RF_test, label = 'recall_RF_test-precision_RF_test')
plt.plot(precision_LR_train, recall_LR_train, linestyle = '--', label = 'recall_LR_train-precision_LR_train')
plt.plot(precision_LR_test, recall_LR_test, linestyle = '--', label = 'recall_LR_test-precision_LR_test')
plt.title('recall-precision')
plt.xlabel('precision')
plt.ylabel('recall')
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1))
plt.show()

plt.clf()
#plt.plot(fpr_GM_train, tpr_GM_train, label = 'tpr_GM_train vs. fpr_GM_train', linewidth = 2.0)
#plt.plot(fpr_GM_test, tpr_GM_test, label = 'tpr_GM_test vs. fpr_GM_test', linewidth = 2.0)
#plt.plot(fpr_SV_train, tpr_SV_train, label = 'tpr_SV_train vs. fpr_SV_train', linewidth = 2.0)
#plt.plot(fpr_SV_test, tpr_SV_test, label = 'tpr_SV_test vs. fpr_SV_test', linewidth = 2.0)
#plt.plot(fpr_NN_train, tpr_NN_train, label = 'tpr_NN_train vs. fpr_NN_train', linewidth = 2.0)
#plt.plot(fpr_NN_test, tpr_NN_test, label = 'tpr_NN_test vs. fpr_NN_test', linewidth = 2.0)
plt.plot(fpr_RF_train, tpr_RF_train, label = 'tpr_RF_train vs. fpr_RF_train', linewidth = 2.0)
plt.plot(fpr_RF_test, tpr_RF_test, label = 'tpr_RF_test vs. fpr_RF_test', linewidth = 2.0)
plt.plot(fpr_LR_train, tpr_LR_train, linestyle = '--', label = 'tpr_LR_train vs. fpr_LR_train')
plt.plot(fpr_LR_test, tpr_LR_test, linestyle = '--', label = 'tpr_LR_test vs. fpr_LR_test')
plt.plot([0, 1], [0, 1], linestyle = '-.', label = 'Random Guess')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1), fontsize = 18)
plt.show()




positive = np.random.normal(loc = -1, scale = 0.5, size = 1000)
negative = np.random.normal(loc = -1, scale = 0.5, size = 1000)

predicted = np.concatenate((positive, negative))
real = [1] * 1000 + [0] * 1000

fpr, tpr, thresholds = sklearn.metrics.roc_curve(real, predicted)

plt.clf()
plt.hist(positive, bins = 30, color = 'r', alpha = 0.7)
plt.hist(negative, bins = 30, color = 'g', alpha = 0.7)
plt.xlim([-3, 4])
plt.show()

plt.clf()
plt.plot(fpr, tpr, linewidth = 2.0)
plt.plot([0, 1], [0, 1], linestyle = '-.')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1))
plt.show()


#%% Promotion Prediction



# Importing and renaming datasets

Master = pd.read_csv('C:/Personal/71069232/Documents/PepsiCo/Machine Learning/Turnover Prediction/2016 Modeling/Global L8+ 2012-2014_Promo.csv', na_values = [' ']) 

Master.columns = Master.columns.str.lower()

colNames = list(Master.columns.values)

# Global L8+ Models
# Master[['status', 'emplid']].groupby('status').agg(lambda x: len(x))

indVars = """Year_2012 Year_2013  /*Year_2014*/  
/*wkcountry_US*/ wkcountry_Canada wkcountry_Mexico wkcountry_Russia wkcountry_UK  wkcountry_India  wkcountry_China  wkcountry_Brazil  wkcountry_Egypt wkcountry_Spain 
wkcountry_UAE wkcountry_Australia wkcountry_Ireland wkcountry_Thailand wkcountry_Colombia wkcountry_Turkey wkcountry_Argentina wkcountry_Venezuela wkcountry_Poland 
wkcountry_France wkcountry_SaudiArabia wkcountry_Ukraine wkcountry_SouthAfrica wkcountry_Netherlands wkcountry_Switzerland wkcountry_othergll8
age gender_female 
tenservice tenband  Expat
 supervisor /*bandlevel_L8*/ bandlevel_L9 bandlevel_L10 bandlevel_L11 bandlevel_B1 bandlevel_B2 bandlevel_B3 bandlevel_B4 bandlevel_B5
HighPotential_CurYr /*KeyContributor_CurYr*/ CriticalProfessional_CurYr  PerformanceConcern_CurYr  Potential_CurYr_MISS 
Pay_BdRatio_CompaRatio   /*BonusTotal_AtTarget*/  PayChangeBasePCT PayChangeBasePCT_miss
lateral_division lateral_function newhire  Global_grp  
 function_BIS function_Sales function_Communications function_Finance function_Franchise function_GM function_HR function_Insights function_Legal function_Marketing 
function_Procurement function_RND /*function_SupplyChain_Ops*/
supSOC SupAge_DiffEE  Suptenservice SupChg
Suptscore SupTscore_miss  
grpvolturn GrpTenure_Mean
Chg_fromHiPo   
LowPerformer_CurYr /*AveragePerformer_CurYr*/ HighPerformer_CurYr_GE7 TCIndex_CurYr_MISS"""


indVars = indVars.lower()
indVars = re.sub("\\n+", " ", indVars)
indVars = re.sub("/\\*[^*]*\\*/", " ", indVars)
indVars = re.sub("^\\s+|\\s+$", "", indVars)
indVars = re.sub("\\s+", " ", indVars)
indVars = indVars.split(" ")

# all([_ in colNames for _ in indVars])
# set(indVars).issubset(set(colNames))

ModelData = Master[indVars + ['promo_cross_lead1']]
ModelData = ModelData.dropna(how = 'any')

X = ModelData[indVars]
y = ModelData.promo_cross_lead1

# Normalize the variables to the same scale
X_scaled = pd.DataFrame(preprocessing.scale(X), columns = X.columns.values)

# Split the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.3, random_state=42)


# sum(X.isnull().values.ravel())

# X.dtypes.to_clipboard()

# Logistic Regression

lrc = LogisticRegression(C = 1000000)

lrc.fit(X_train, y_train)

lrc.score(X_train, y_train)

prob_pred_LR_train = lrc.predict_proba(X_train)[:, 1]
prob_pred_LR_test = lrc.predict_proba(X_test)[:, 1]

precision_LR_train, recall_LR_train, thresholds_LR_train_PR = sklearn.metrics.precision_recall_curve(y_train, prob_pred_LR_train)
precision_LR_test, recall_LR_test, thresholds_LR_test_PR = sklearn.metrics.precision_recall_curve(y_test, prob_pred_LR_test)

fpr_LR_train, tpr_LR_train, thresholds_LR_train_ROC = sklearn.metrics.roc_curve(y_train, prob_pred_LR_train)
fpr_LR_test, tpr_LR_test, thresholds_LR_test_ROC = sklearn.metrics.roc_curve(y_test, prob_pred_LR_test)

thresholds_LR_train_PR = np.insert(thresholds_LR_train_PR, 0, 0)
thresholds_LR_test_PR = np.insert(thresholds_LR_test_PR, 0, 0)

#GlobalL8p_Result.score(X, y)
#
#y_prob = pd.DataFrame(GlobalL8p_Result.predict_proba(X))
#
#Classification = pd.DataFrame(data = {'vol_term_lead1': y, 'predicted_vol_term_probability': y_prob[1]})
#
#Classification['y_pred'] = Classification['predicted_vol_term_probability'].map(lambda x: int(x > 0.1))
#
#pd.crosstab(Classification.vol_term_lead1, Classification.y_pred, colnames = ['y_pred'])
#

# Coefficient
# pd.DataFrame(zip(X.columns, np.transpose(GlobalL8p_Result.coef_))).to_clipboard()


# Random Forest

rfc = RandomForestClassifier(n_estimators = 100, max_features = 'auto', min_samples_split = 20, max_depth = 5, n_jobs = 4, oob_score = True)
rfc.fit(X_train, y_train)

rfc.score(X_train, y_train)


plt.bar(range(X_train.shape[1]), rfc.feature_importances_)
plt.show()
X.columns.values
feature_ranking = pd.DataFrame({'feature': X.columns.values, 'importance': rfc.feature_importances_})
feature_ranking.to_clipboard()


prob_pred_RF_train = rfc.predict_proba(X_train)[:, 1]
prob_pred_RF_test = rfc.predict_proba(X_test)[:, 1]

precision_RF_train, recall_RF_train, thresholds_RF_train_PR = sklearn.metrics.precision_recall_curve(y_train, prob_pred_RF_train)
precision_RF_test, recall_RF_test, thresholds_RF_test_PR = sklearn.metrics.precision_recall_curve(y_test, prob_pred_RF_test)

fpr_RF_train, tpr_RF_train, thresholds_RF_train_ROC = sklearn.metrics.roc_curve(y_train, prob_pred_RF_train)
fpr_RF_test, tpr_RF_test, thresholds_RF_test_ROC = sklearn.metrics.roc_curve(y_test, prob_pred_RF_test)

thresholds_RF_train_PR = np.insert(thresholds_RF_train_PR, 0, 0)
thresholds_RF_test_PR = np.insert(thresholds_RF_test_PR, 0, 0)



plt.clf()
plt.plot(fpr_RF_train, tpr_RF_train, label = 'tpr_RF_train vs. fpr_RF_train', linewidth = 2.0)
plt.plot(fpr_RF_test, tpr_RF_test, label = 'tpr_RF_test vs. fpr_RF_test', linewidth = 2.0)
plt.plot(fpr_LR_train, tpr_LR_train, linestyle = '--', label = 'tpr_LR_train vs. fpr_LR_train')
plt.plot(fpr_LR_test, tpr_LR_test, linestyle = '--', label = 'tpr_LR_test vs. fpr_LR_test')
plt.plot([0, 1], [0, 1], linestyle = '-.', label = 'Random Guess')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1), fontsize = 18)
plt.show()




# Multi-layer Perceptron

mlpc = MLPClassifier(hidden_layer_sizes = (20,), activation = 'logistic', alpha = 0.05)
mlpc.fit(X_train, y_train)

prob_pred_NN_train = mlpc.predict_proba(X_train)[:, 1]
prob_pred_NN_test = mlpc.predict_proba(X_test)[:, 1]

precision_NN_train, recall_NN_train, thresholds_NN_train_PR = sklearn.metrics.precision_recall_curve(y_train, prob_pred_NN_train)
precision_NN_test, recall_NN_test, thresholds_NN_test_PR = sklearn.metrics.precision_recall_curve(y_test, prob_pred_NN_test)

fpr_NN_train, tpr_NN_train, thresholds_NN_train_ROC = sklearn.metrics.roc_curve(y_train, prob_pred_NN_train)
fpr_NN_test, tpr_NN_test, thresholds_NN_test_ROC = sklearn.metrics.roc_curve(y_test, prob_pred_NN_test)

thresholds_NN_train_PR = np.insert(thresholds_NN_train_PR, 0, 0)
thresholds_NN_test_PR = np.insert(thresholds_NN_test_PR, 0, 0)



plt.clf()
plt.plot(fpr_NN_train, tpr_NN_train, label = 'tpr_NN_train vs. fpr_NN_train', linewidth = 2.0)
plt.plot(fpr_NN_test, tpr_NN_test, label = 'tpr_NN_test vs. fpr_NN_test', linewidth = 2.0)
plt.plot(fpr_LR_train, tpr_LR_train, linestyle = '--', label = 'tpr_LR_train vs. fpr_LR_train')
plt.plot(fpr_LR_test, tpr_LR_test, linestyle = '--', label = 'tpr_LR_test vs. fpr_LR_test')
plt.plot([0, 1], [0, 1], linestyle = '-.', label = 'Random Guess')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1), fontsize = 18)
plt.show()




# Support Vector Classification
#for const in np.linspace(1e-5, 1e-2, num = 10):
#    for gammaVal in np.linspace(1e-2, 1e1, num = 20):
svc = SVC(C = 0.001, probability = True, gamma = 0.006, kernel = 'rbf', cache_size = 10000)
svc.fit(X_train, y_train)
svc.score(X_train, y_train)

prob_pred_SV_train = svc.predict_proba(X_train)[:, 1]
prob_pred_SV_test = svc.predict_proba(X_test)[:, 1]

precision_SV_train, recall_SV_train, thresholds_SV_train_PR = sklearn.metrics.precision_recall_curve(y_train, prob_pred_SV_train)
precision_SV_test, recall_SV_test, thresholds_SV_test_PR = sklearn.metrics.precision_recall_curve(y_test, prob_pred_SV_test)

fpr_SV_train, tpr_SV_train, thresholds_SV_train_ROC = sklearn.metrics.roc_curve(y_train, prob_pred_SV_train)
fpr_SV_test, tpr_SV_test, thresholds_SV_test_ROC = sklearn.metrics.roc_curve(y_test, prob_pred_SV_test)

thresholds_SV_train_PR = np.insert(thresholds_SV_train_PR, 0, 0)
thresholds_SV_test_PR = np.insert(thresholds_SV_test_PR, 0, 0)
        
#print const, gammaVal
        

plt.clf()
plt.plot(fpr_SV_train, tpr_SV_train, label = 'tpr_SV_train vs. fpr_SV_train', linewidth = 2.0)
plt.plot(fpr_SV_test, tpr_SV_test, label = 'tpr_SV_test vs. fpr_SV_test', linewidth = 2.0)
plt.plot(fpr_LR_train, tpr_LR_train, linestyle = '--', label = 'tpr_LR_train vs. fpr_LR_train')
plt.plot(fpr_LR_test, tpr_LR_test, linestyle = '--', label = 'tpr_LR_test vs. fpr_LR_test')
plt.plot([0, 1], [0, 1], linestyle = '-.', label = 'Random Guess')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1), fontsize = 18)
plt.show()





# Anomaly Detection

gmc = GaussianMixture(n_components = 76)
X_train_2 = X_train[list(y_train == 0)]
gmc.fit(X_train_2)

prob_pred_GM_train = np.exp(gmc.score_samples(X_train))
prob_pred_GM_test = np.exp(gmc.score_samples(X_test))

precision_GM_train, recall_GM_train, thresholds_GM_train_PR = sklearn.metrics.precision_recall_curve(y_train, prob_pred_GM_train)
precision_GM_test, recall_GM_test, thresholds_GM_test_PR = sklearn.metrics.precision_recall_curve(y_test, prob_pred_GM_test)

fpr_GM_train, tpr_GM_train, thresholds_GM_train_ROC = sklearn.metrics.roc_curve(y_train, prob_pred_GM_train)
fpr_GM_test, tpr_GM_test, thresholds_GM_test_ROC = sklearn.metrics.roc_curve(y_test, prob_pred_GM_test)

thresholds_GM_train_PR = np.insert(thresholds_GM_train_PR, 0, 0)
thresholds_GM_test_PR = np.insert(thresholds_GM_test_PR, 0, 0)


plt.clf()
plt.plot(fpr_GM_train, tpr_GM_train, label = 'tpr_GM_train vs. fpr_GM_train', linewidth = 2.0)
plt.plot(fpr_GM_test, tpr_GM_test, label = 'tpr_GM_test vs. fpr_GM_test', linewidth = 2.0)
plt.plot(fpr_LR_train, tpr_LR_train, linestyle = '--', label = 'tpr_LR_train vs. fpr_LR_train')
plt.plot(fpr_LR_test, tpr_LR_test, linestyle = '--', label = 'tpr_LR_test vs. fpr_LR_test')
plt.plot([0, 1], [0, 1], linestyle = '-.', label = 'Random Guess')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1), fontsize = 18)
plt.show()







prob_pred_MAX_train = pd.DataFrame(zip(prob_pred_LR_train, prob_pred_RF_train, prob_pred_NN_train)).max(axis = 1)
fpr_MAX_train, tpr_MAX_train, thresholds_MAX_train_ROC = sklearn.metrics.roc_curve(y_train, prob_pred_MAX_train)


prob_pred_MAX_test = pd.DataFrame(zip(prob_pred_LR_test, prob_pred_RF_test, prob_pred_NN_test)).max(axis = 1)
fpr_MAX_test, tpr_MAX_test, thresholds_MAX_test_ROC = sklearn.metrics.roc_curve(y_test, prob_pred_MAX_test)



plt.clf()
plt.plot(fpr_MAX_train, tpr_MAX_train, label = 'tpr_MAX_train vs. fpr_MAX_train', linewidth = 2.0)
plt.plot(fpr_MAX_test, tpr_MAX_test, label = 'tpr_MAX_test vs. fpr_MAX_test', linewidth = 2.0)
plt.plot(fpr_LR_train, tpr_LR_train, linestyle = '--', label = 'tpr_LR_train vs. fpr_LR_train')
plt.plot(fpr_LR_test, tpr_LR_test, linestyle = '--', label = 'tpr_LR_test vs. fpr_LR_test')
plt.plot([0, 1], [0, 1], linestyle = '-.', label = 'Random Guess')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1), fontsize = 18)
plt.show()




# Plot Results

plt.clf()
#plt.plot(thresholds_GM_train_PR, precision_GM_train, label = 'precision_GM_train-Threshold')
#plt.plot(thresholds_GM_train_PR, recall_GM_train, label = 'recall_GM_train-Threshold')
#plt.plot(thresholds_GM_test_PR, precision_GM_test, label = 'precision_GM_test-Threshold')
#plt.plot(thresholds_GM_test_PR, recall_GM_test, label = 'recall_GM_test-Threshold')
plt.plot(thresholds_SV_train_PR, precision_SV_train, label = 'precision_SV_train-Threshold')
plt.plot(thresholds_SV_train_PR, recall_SV_train, label = 'recall_SV_train-Threshold')
plt.plot(thresholds_SV_test_PR, precision_SV_test, label = 'precision_SV_test-Threshold')
plt.plot(thresholds_SV_test_PR, recall_SV_test, label = 'recall_SV_test-Threshold')
#plt.plot(thresholds_NN_train_PR, precision_NN_train, label = 'precision_NN_train-Threshold')
#plt.plot(thresholds_NN_train_PR, recall_NN_train, label = 'recall_NN_train-Threshold')
#plt.plot(thresholds_NN_test_PR, precision_NN_test, label = 'precision_NN_test-Threshold')
#plt.plot(thresholds_NN_test_PR, recall_NN_test, label = 'recall_NN_test-Threshold')
#plt.plot(thresholds_RF_train_PR, precision_RF_train, label = 'precision_RF_train-Threshold')
#plt.plot(thresholds_RF_train_PR, recall_RF_train, label = 'recall_RF_train-Threshold')
#plt.plot(thresholds_RF_test_PR, precision_RF_test, label = 'precision_RF_test-Threshold')
#plt.plot(thresholds_RF_test_PR, recall_RF_test, label = 'recall_RF_test-Threshold')
plt.plot(thresholds_LR_train_PR, precision_LR_train, linestyle = '--', label = 'precision_LR_train-Threshold')
plt.plot(thresholds_LR_train_PR, recall_LR_train, linestyle = '--', label = 'recall_LR_train-Threshold')
plt.plot(thresholds_LR_test_PR, precision_LR_test, linestyle = '--', label = 'precision_LR_test-Threshold')
plt.plot(thresholds_LR_test_PR, recall_LR_test, linestyle = '--', label = 'recall_LR_test-Threshold')
plt.title('recall-precision-Threshold')
plt.xlabel('Threshold')
plt.ylabel('recall_RF/precision_RF')
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1))
plt.show()

plt.clf()
#plt.plot(precision_GM_train, recall_GM_train, label = 'recall_GM_train-precision_GM_train')
#plt.plot(precision_GM_test, recall_GM_test, label = 'recall_GM_test-precision_GM_test')
plt.plot(precision_SV_train, recall_SV_train, label = 'recall_SV_train-precision_SV_train')
plt.plot(precision_SV_test, recall_SV_test, label = 'recall_SV_test-precision_SV_test')
#plt.plot(precision_NN_train, recall_NN_train, label = 'recall_NN_train-precision_NN_train')
#plt.plot(precision_NN_test, recall_NN_test, label = 'recall_NN_test-precision_NN_test')
#plt.plot(precision_RF_train, recall_RF_train, label = 'recall_RF_train-precision_RF_train')
#plt.plot(precision_RF_test, recall_RF_test, label = 'recall_RF_test-precision_RF_test')
plt.plot(precision_LR_train, recall_LR_train, linestyle = '--', label = 'recall_LR_train-precision_LR_train')
plt.plot(precision_LR_test, recall_LR_test, linestyle = '--', label = 'recall_LR_test-precision_LR_test')
plt.title('recall-precision')
plt.xlabel('precision')
plt.ylabel('recall')
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1))
plt.show()

plt.clf()
#plt.plot(fpr_GM_train, tpr_GM_train, label = 'tpr_GM_train vs. fpr_GM_train', linewidth = 2.0)
#plt.plot(fpr_GM_test, tpr_GM_test, label = 'tpr_GM_test vs. fpr_GM_test', linewidth = 2.0)
#plt.plot(fpr_SV_train, tpr_SV_train, label = 'tpr_SV_train vs. fpr_SV_train', linewidth = 2.0)
#plt.plot(fpr_SV_test, tpr_SV_test, label = 'tpr_SV_test vs. fpr_SV_test', linewidth = 2.0)
#plt.plot(fpr_NN_train, tpr_NN_train, label = 'tpr_NN_train vs. fpr_NN_train', linewidth = 2.0)
#plt.plot(fpr_NN_test, tpr_NN_test, label = 'tpr_NN_test vs. fpr_NN_test', linewidth = 2.0)
plt.plot(fpr_RF_train, tpr_RF_train, label = 'tpr_RF_train vs. fpr_RF_train', linewidth = 2.0)
plt.plot(fpr_RF_test, tpr_RF_test, label = 'tpr_RF_test vs. fpr_RF_test', linewidth = 2.0)
plt.plot(fpr_LR_train, tpr_LR_train, linestyle = '--', label = 'tpr_LR_train vs. fpr_LR_train')
plt.plot(fpr_LR_test, tpr_LR_test, linestyle = '--', label = 'tpr_LR_test vs. fpr_LR_test')
plt.plot([0, 1], [0, 1], linestyle = '-.', label = 'Random Guess')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1), fontsize = 18)
plt.show()




positive = np.random.normal(loc = -1, scale = 0.5, size = 1000)
negative = np.random.normal(loc = -1, scale = 0.5, size = 1000)

predicted = np.concatenate((positive, negative))
real = [1] * 1000 + [0] * 1000

fpr, tpr, thresholds = sklearn.metrics.roc_curve(real, predicted)

plt.clf()
plt.hist(positive, bins = 30, color = 'r', alpha = 0.7)
plt.hist(negative, bins = 30, color = 'g', alpha = 0.7)
plt.xlim([-3, 4])
plt.show()

plt.clf()
plt.plot(fpr, tpr, linewidth = 2.0)
plt.plot([0, 1], [0, 1], linestyle = '-.')
plt.title('ROC Curve', fontsize = 24)
plt.xlabel('False Positive Rate', fontsize = 18)
plt.ylabel('True Positive Rate', fontsize = 18)
plt.xlim([-0.1, 1.1])
plt.ylim([-0.1, 1.1])
plt.xticks(fontsize = 14)
plt.yticks(fontsize = 14)
plt.legend(loc = 'upper left', bbox_to_anchor = (1, 1))
plt.show()



