#!/usr/bin/python3

import pandas as pd
import datetime as dt

path = "/home/tomo/Dropbox/Markdown/Finanzen/ausgaben.csv"
format = "%Y.%m.%d %H:%M"

# reading and preprocessing data
df = pd.read_csv(path, delimiter=';')
df["Datum Zeit"] = pd.to_datetime(df["Datum Zeit"], format=format)
df.set_index("Datum Zeit", inplace=True)
df["Betrag"] = pd.to_numeric(df["Betrag"])
df["Tags"] = df["Tags"].str.replace(" ", "").str.slice(1).str.lower().str.split(pat="#")

# filter lists - maybe outsourced to a config file

essen = ["nahrung", "nahrungsmittel", "essen", "eat", "gastro"]
bildung = ["bildung", "bücher", "coding", "udemy"]
it = ["it", "software"]
sport = ["sport", "bewegung", "verein", "1880"]
medizin = ["medizin", "medis", "apo", "apotheke"]
haushalt = ["haushalt", "drogerie"]

kategorien = {
    "Essen   ":essen,
    "Medizin ":medizin,
    "Bildung ":bildung,
    "Sport   ":sport,
    "IT      ":it,
    "Haushalt":haushalt
}

month = {
    "Januar":1,
    "Februar":2,
    "März":3,
    "April":4,
    "Mai":5,
    "Juni":6,
    "Juli":7,
    "August":8,
    "September":9,
    "Oktober":10,
    "November":11,
    "Dezember":12
}

def get_name_for_month(number):
    for name, value in month.items():
        if value == number: return name
    return "Nothing"

# filter for tag list
def filter_for_tag_list(tag_list):
    def has_common_tag(x):
        for tag1 in x:
            for tag2 in tag_list:
                if tag1 == tag2: return True
        return False
    return df["Tags"].apply(has_common_tag)

# output
def output(month, year):
    datum = f"{year}-{month:02}"
    betrag = "Betrag"
    #print(df[datum]["Tags"])
    print(f"\nFinanzen Ausgaben {get_name_for_month(month)} {year}:")
    print("------------------------------")
    for kat, lst in kategorien.items():
        print(f"{kat}\t{df[filter_for_tag_list(lst)].loc[datum][betrag].sum():.2f} EUR")
    print(f"Gesamt \t\t{df.loc[datum][betrag].sum():.2f} EUR")
    print(f"")

this_month = int(dt.datetime.now().strftime("%m"))
this_year = int(dt.datetime.now().strftime("%Y"))

output(this_month, this_year)
output(9,2021)








