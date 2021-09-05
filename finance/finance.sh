#!/usr/bin/python3

import datetime as dt
import pandas as pd

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

# filter for tag list
def filter_for_tag_list(tag_list):
    def has_same_tag(x):
        for tag1 in x:
            for tag2 in tag_list:
                if tag1 == tag2: return True
        return False
    return df["Tags"].apply(has_same_tag)

# output
def output():
    monat = "September"
    datum = "2021-"+monat
    betrag = "Betrag"
    #print(df[datum]["Tags"])
    print(f"\nFinanzen Aufteilung {monat}:")
    print("--------------------------------------------------------------------------------")
    for kat, lst in kategorien.items():
        print(f"{kat}\t{df[filter_for_tag_list(lst)].loc[datum][betrag].sum():.2f} EUR")
    print(f"Gesamt \t{df.loc[datum][betrag].sum():.2f} EUR")
    print(f"")

output()
