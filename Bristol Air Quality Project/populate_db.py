import mysql.connector
import csv
import pandas as pd

# connects to the mysql database
db = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="Passw0rd12345",
    database="pollution_db" 
    )

# create cursor
mycursor = db.cursor()

df = pd.read_csv("air_quality_update.csv", dtype = {
    "NOx" : "float16",
    "NO2" : "float16",
    "NO" : "float16",
    "SiteID" : "float16",
    "PM10" : "float16",
    "NVPM10" : "float16",
    "VPM10" : "float16",
    "NVPM2.5" : "float16",
    "PM2.5" : "float16",
    "VPM2.5" : "float16",
    "CO" : "float16",
    "O3" : "float16",
    "SO2" : "float16",
    "Temperature" : "float16",
    "RH" : "float16",
    "Air Pressure" : "float16"
}, low_memory=False)

# converts Pandas NaN values to None that sql can read
df = df.where(pd.notnull(df), None)

# creates a dataframe that is like the site table
site_df = df.drop_duplicates( subset="SiteID", keep="first")
site_df = site_df[["SiteID","Location","Latitude","Longitude","DateStart","DateEnd","Current","Instrument Type"]]

# create a list that from the dataframe that we will use to input data in toe sql table
site_list = site_df.to_numpy()
site_list_length = len(site_list)

# create measurement table index 
df.insert(0, 'mID', range(1, 1 + len(df)))

# dataframe that looks like the table in mysql
measurements_df = df[["mID","SiteID","NOx","NO2","NO","PM10","NVPM10","VPM10","NVPM2_5","PM2_5","VPM2_5","CO","O3","SO2","Temperature","RH","Air Pressure","Date","Time"]]

# creates list from dataframe
measurements_list = measurements_df.to_numpy()
measurements_list_length = len(measurements_list)

print(site_list)
print("***********************************************************************************")

# insert into site table
sql = "INSERT INTO site (SiteID,Location,Latitude,Longitude,StartDate,EndDate,Current,Instrument) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
mycursor.executemany(sql, tuple(site_list))

print("task 1 complete")

n = 1
# insert into the measuremnts table
for row in measurements_list:    
    sql = "INSERT INTO measurement(mID,SiteID,NOx,NO2,NO,PM10,NVPM10,VPM10,NVPM2_5,PM2_5,VPM2_5,CO,O3,SO2,Temperature,RH,Air_Pressure,Date,Time) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    mycursor.execute(sql, tuple(row))
    print("row added", n )
    n += 1
    
db.commit()

print("task 2 complete")

