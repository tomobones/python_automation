#!/usr/bin/python3

'''
TODO
- ALLE ständige Ausgaben eintragen!!!!
- mehrere outputs: detail, short
- Netto Betrag immer angeben
- Ständig: Eingänge und Ausgänge gesondert betrachten
- Feld "Monate" berücksichtigen, Testen
- Statistiken
    - Charts anzeigen der Irregulären Ausgaben
    - für verschiedene Rubriken
    - Durchschnittswerte für Rubriken
    - Std abweichungen für Rubriken
    - Torte aller ständigen Ausgaben
    - Relation einzelner Posten Ausgaben zum Gesamteingang
    - Kummulierende der Netto Ausgaben
- Top 10 der höchsten Ausgaben
'''

# alias grepfin='grep -vE "^[0-9]{1,3};20[0-9]{2}\.[01][0-9]\.[0123][0-9] [012][0-9]:[0-5][0-9];[0-9]+\.[0-9]{2};[^;]+;[^;]+;[^;]+$"'

import pandas as pd
import datetime as dt

path_once = "/home/tomo/NextCloud/Markdown/Finanzen/ausgaben.csv"
path_monthly = "/home/tomo/NextCloud/Markdown/Finanzen/ausgaben_monatlich.csv"
format_once = "%Y.%m.%d %H:%M"
format_monthly = "%Y.%m"

# reading and preprocessing data

df_once = pd.read_csv(path_once, delimiter=';')
df_once["Datum Zeit"] = pd.to_datetime(df_once["Datum Zeit"], format=format_once)
df_once.set_index("Datum Zeit", inplace=True)
df_once["Betrag"] = pd.to_numeric(df_once["Betrag"])
df_once["Tags"] = df_once["Tags"].str.replace(" ", "").str.slice(1).str.lower().str.split(pat="#")

df_monthly = pd.read_csv(path_monthly, delimiter=';')
df_monthly["Datum_ab"] = pd.to_datetime(df_monthly["Datum_ab"], format=format_monthly, errors='coerce')
df_monthly["Datum_bis"] = pd.to_datetime(df_monthly["Datum_bis"], format=format_monthly, errors='coerce')
#df_monthly["Monate"] = df_monthly["Monate"].str.replace(" ", "").str.split(pat=",")

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

# filter

def filter_for_tag_list(tag_list):
    def has_common_tag(x):
        for tag1 in x:
            for tag2 in tag_list:
                if tag1 == tag2: return True
        return False
    return df_once["Tags"].apply(has_common_tag)

def filter_is_due_in(this_month):
    after_start = df_monthly["Datum_ab"] <= this_month
    before_end = df_monthly["Datum_bis"] >= this_month
    no_start = pd.isnull(df_monthly["Datum_ab"])
    no_end = pd.isnull(df_monthly["Datum_bis"])
    return (no_start | after_start) & (no_end | before_end)
    

# output functions

def output_irregular(month, year):
    datum = f"{year}-{month:02}"
    filter_monatlich = filter_is_due_in(dt.datetime(year, month, 1))
    betrag = "Betrag"
    gesamt_einmalig = df_once.loc[datum][betrag].sum()
    gesamt_monatlich =  df_monthly.loc[filter_monatlich]['Betrag'].sum()
    print(f"\nAusgaben für {get_name_for_month(month)} {year}")
    print("-------------------------------")
    for kat, lst in kategorien.items():
        print(f"{kat:<20}{df_once[filter_for_tag_list(lst)].loc[datum][betrag].sum():7.2f} EUR")
    print(f"Gesamt              {gesamt_einmalig:7.2f} EUR")

def output_monthly(month, year):
    filter_monatlich = filter_is_due_in(dt.datetime(year, month, 1))
    filter_gehalt = df_monthly['Name'].str.contains('Gehalt', case=False)
    gesamt_monatlich =  df_monthly.loc[~filter_gehalt & filter_monatlich]['Betrag'].sum()
    gehalt =  df_monthly.loc[filter_gehalt & filter_monatlich]['Betrag'].sum()
    print(f"\nStändige Ausgaben Stand {get_name_for_month(month)} {year}")
    print("-------------------------------")
    for index, row in df_monthly[~filter_gehalt & filter_monatlich].iterrows():
        print(f"{row['Name']:<20}{row['Betrag']:7.2f} EUR")
    print("")
    print(f"Gesamt Ausgaben     {gesamt_monatlich:7.2f} EUR")
    print(f"Gehalt             {gehalt:7.2f} EUR")
    print(f"Netto Ausgaben     {gesamt_monatlich + gehalt:7.2f} EUR")

def output_summary(month, year):
    datum = f"{year}-{month:02}"
    filter_monatlich = filter_is_due_in(dt.datetime(year, month, 1))
    filter_gehalt = df_monthly['Name'].str.contains('Gehalt', case=False)
    betrag = "Betrag"
    gesamt_einmalig = df_once.loc[datum][betrag].sum()
    gesamt_monatlich =  df_monthly.loc[~filter_gehalt & filter_monatlich]['Betrag'].sum()
    gehalt =  df_monthly.loc[filter_gehalt & filter_monatlich]['Betrag'].sum()
    print(f"\nZusammenfassung {get_name_for_month(month)} {year}")
    print("-------------------------------")
    print(f"Ausgaben {get_name_for_month(month):<10} {gesamt_einmalig:7.2f} EUR")
    print(f"Ständige Ausgaben   {gesamt_monatlich:7.2f} EUR")
    print(f"Gehalt             {gehalt:7.2f} EUR")
    print(f"Netto Ausgaben      {gehalt + gesamt_monatlich + gesamt_einmalig:7.2f} EUR")

# helper functions

def month_before(month, year):
    if month > 1: return month - 1, year
    else: return 12, year - 1
    

this_month = int(dt.datetime.now().strftime("%m"))
this_year = int(dt.datetime.now().strftime("%Y"))

output_irregular(this_month, this_year)
output_summary(this_month, this_year)
output_summary(*month_before(this_month, this_year))
output_summary(*month_before(*month_before(this_month, this_year)))
print("")








