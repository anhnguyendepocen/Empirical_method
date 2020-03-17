import pandas as pd
import geopy.distance as geodist
import numpy as np

prefecture = pd.read_excel("Prefecture.xlsx")
temperature = pd.read_excel("Temperature.xlsx")
precipitation = pd.read_excel("Precipitation.xlsx")

numofpre = 47
#Because lack for 2000
startyear = 2001
endyear = 2015

new_data=np.zeros([15*12*47,5])

 
new_rows=0
for preid in range(1,numofpre+1):
    local_temperature=temperature[temperature['pref_id']==preid]
    local_precipitation=precipitation[precipitation['pref_id']==preid]
    for y in range(startyear,endyear+1):
        for m in range(1,13):
            ym_temperature=local_temperature[(local_temperature['year']==y) & (local_temperature['month']==m)]
            ym_precipitation=local_precipitation[(local_precipitation['year']==y) & (local_precipitation['month']==m)]
            
            # Distance
            center_position=prefecture[prefecture['pref_id']==preid]
            center_position=(center_position['latitude'].iloc[0],center_position['longtitude'].iloc[0])
            
            ym_temperature_distance=np.zeros(ym_temperature.shape[0])
            for rows in range(ym_temperature.shape[0]):
                sta_position=(ym_temperature['latitude'].iloc[rows],ym_temperature['longtitude'].iloc[rows])
                ym_temperature_distance[rows]=geodist.distance(center_position,sta_position).km
            #ym_temperature['D']=ym_temperature_distance
            
            # Weighted
            sum_dessq=np.sum((1/ym_temperature_distance)**2)
            ym_temperature_weight=(1/ym_temperature_distance**2)/sum_dessq
            
            #Create new data
            
            new_data[new_rows][0]=preid
            new_data[new_rows][1]=y
            new_data[new_rows][2]=m
            for w in range(ym_temperature.shape[0]):
                new_data[new_rows][3]=new_data[new_rows][3]+ym_temperature_weight[w]*ym_temperature['temperature'].iloc[w]
                new_data[new_rows][4]=new_data[new_rows][4]+ym_temperature_weight[w]*ym_precipitation['prec'].iloc[w]
            new_rows=new_rows+1
            
            
            
            
new_csv=pd.DataFrame(new_data)        
new_csv.to_csv('Problem1.csv')   
