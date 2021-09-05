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
medizin = ["medizin", "medis", "apo", "apotheke"]
bildung = ["bildung", "bücher", "coding", "udemy"]
it = ["it", "software"]
sport = ["sport", "bewegung", "verein", "1880"]

kategorien = {
    "Essen":essen,
    "Medizin":medizin,
    "Bildung":bildung,
    "Sport":sport,
    "IT":it
}

monate = {
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
    for name, value in monate.items():
        if value == number: return name
    return "Nothing"

# filter for tag list
def filter_for_tag_list(tag_list):
    def has_same_tag(x):
        for tag1 in x:
            for tag2 in tag_list:
                if tag1 == tag2: return True
        return False
    return df["Tags"].apply(has_same_tag)

# output
def output(monat):
    datum = "2021-"+str(monat)
    betrag = "Betrag"
    #print(df[datum]["Tags"])
    print(f"\nFinanzen Aufteilung {get_name_for_month(monat)}:")
    print("------------------------------")
    for kat, lst in kategorien.items():
        print(f"{kat}\t{df[filter_for_tag_list(lst)].loc[datum][betrag].sum():.2f} EUR")
    print(f"Gesamt \t{df.loc[datum][betrag].sum():.2f} EUR")
    print(f"")

this_month = dt.datetime.now().strftime("%m")
output(int(this_month))
