import pandas as pd
import csv

df = pd.read_csv("random_test.csv")

'''
for row in df_clean:

    if (row["SiteID"] == 188) & (row["Location"] == "AURN Bristol Centre"):
        df_filtered = pd.concat(row, ignore_index=True)

    elif (row["SiteID"] == 203) & (row["Location"] == "Brislington Depot"):
        df_filtered = pd.concat(row, ignore_index=True)
    
    elif (row["SiteID"] == 206) & (row["Location"] == "Rupert Street"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 209) & (row["Location"] == "IKEA M32"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 213) & (row["Location"] == "Old Market"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 215) & (row["Location"] == "Parson Street School"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 228) & (row["Location"] == "Temple Meads Station"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 270) & (row["Location"] == "Wells Road"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 271) & (row["Location"] == "Trailer Portway P&R"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 375) & (row["Location"] == "Newfoundland Road Police Station"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 395) & (row["Location"] == "Shiner's Garage"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 452) & (row["Location"] == "AURN St Pauls"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 447) & (row["Location"] == "Bath Road"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 459) & (row["Location"] == "Cheltenham Road \ Station Road"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 463) & (row["Location"] == "Fishponds Road"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 481) & (row["Location"] == "CREATE Centre Roof"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 500) & (row["Location"] == "Temple Way"):
        df_filtered = pd.concat(row, ignore_index=True)
        
    elif (row["SiteID"] == 501) & (row["Location"] == "Colston Avenue"):
        df_filtered = pd.concat(row, ignore_index=True)
                                
    else:
        print("[",row["SiteID"],"] did not match [", row["Location"], "] at line", row.index)
        df_mismatch = pd.concat(row)
'''

filter_data = (df["SiteID"] == 188) & (df["Location"] == "AURN Bristol Centre")
dfa = df.loc[filter_data]

filter_data = (df["SiteID"] == 203) & (df["Location"] == "Brislington Depot")
dfb = df.loc[filter_data]

filter_data = (df["SiteID"] == 206) & (df["Location"] == "Rupert Street")
dfc = df.loc[filter_data]

filter_data = (df["SiteID"] == 209) & (df["Location"] == "IKEA M32")
dfd = df.loc[filter_data]

filter_data = (df["SiteID"] == 213) & (df["Location"] == "Old Market")
dfe = df.loc[filter_data]

filter_data = (df["SiteID"] == 215) & (df["Location"] == "Parson Street School")
dff = df.loc[filter_data]

filter_data = (df["SiteID"] == 228) & (df["Location"] == "Temple Meads Station")
dfg = df.loc[filter_data]

filter_data = (df["SiteID"] == 270) & (df["Location"] == "Wells Road")
dfh = df.loc[filter_data]


# create final dataframe with rows we want
df1 = pd.concat([dfa,dfb,dfc,dfd,dfe,dff,dfg,dfh], ignore_index=True)

# create dataframe with rows we don't want
df2 = pd.concat([df, df1]).drop_duplicates(keep=False)

for index, row in df2.iterrows():
    print ("[",row["SiteID"],"] did not match [", row["Location"], "] at line", row.name)

print(len(df2), "found in total")





