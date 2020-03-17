import statsmodels.api as sm
import pandas as pd
import numpy as np
from linearmodels import PanelOLS
startyear=2001
endyear=2015
#Step1 : Tackle with the data(Have run)
'''
data = pd.read_csv("Problem1.csv")
new_data= np.zeros([47*15,4])

rows=0
for pid in range(1,48):
    for y in range(startyear,endyear+1):
        local_data=data[(data['year']==y)&(data['pref_id']==pid)]
        new_data[rows,0]=pid
        new_data[rows,1]=y
        new_data[rows,2]=np.mean(local_data['temperature'])
        new_data[rows,3]=np.mean(local_data['prec'])
        rows=rows+1
new_data=pd.DataFrame(new_data)
new_data.to_csv("Problem3.csv")

data1=pd.read_excel("Mortality_rate.xlsx")
data2 = pd.read_csv("Problem3.csv")
rows=0
for pid in range(1,48):
    for y in range(startyear,endyear+1):
        local_data3=data1[data1['pref_id']==pid]
        data2['mr'].iloc[rows]=local_data3['mr'+str(y)].iloc[0]
        rows=rows+1
data2.to_csv("Problem3.csv")
'''

data = pd.read_csv("Problem3&4.csv")
year = pd.Categorical(data.year)
data = data.set_index(['pref_id','year'])
data['year']=year

#Individual&Time FE
exog_vars = ['temperature','temperature2','temperature3','prec','year']
exog_vars2 = ['temperature']
exog = sm.add_constant(data[exog_vars])
exog2 =sm.add_constant(data[exog_vars2])
mod2=sm.OLS(data.mr,exog2)
res2=mod2.fit()

mod = PanelOLS(data.mr,exog,entity_effects=True)
res = mod.fit(cov_type='clustered',cluster_entity=True)

#The result of Model 1
print(res2.summary()) 
#The result of Model 5
print(res) 
