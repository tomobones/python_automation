#!/usr/bin/python3

import datetime as dt
import pandas as pd

path = "/home/tomo/Dropbox/Markdown/Finanzen/ausgaben.csv"
format = "%Y.%m.%d %H:%M"
name_date = "DatumZeit"
df = pd.read_csv(path, delimiter=';')
df["Datum Zeit"] = pd.to_datetime(df["Datum Zeit"], format=format)
df.set_index("Datum Zeit", inplace=True)
df["Betrag"] = pd.to_numeric(df["Betrag"])
df["Tags"] = df["Tags"].str.replace(" ", "").str.slice(1).str.split(pat="#")

#print(df.dtypes)

essen = ["nahrung", "essen", "eat", "gastro"]
bildung = ["bildung", "bücher", "coding", "udemy"]


datum = "2021-sept"
sum = df.loc[datum]["Betrag"].sum()
print(df[datum]["Tags"])
print(f"Summe vom {datum} ist {sum:.2f} EUR")
