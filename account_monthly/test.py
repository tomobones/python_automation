import datetime
import pandas as pd
import numpy as np
import os

import rent_per_owner as rent


# ----------------------------------------------------------------------------
# functions


def load_csv_as_df(csv_file):
    """
    returns dataframe for csv_file
    """

    skipped_rows = list(range(9))
    return pd.read_csv(
        csv_file,
        delimiter=';', 
        skiprows=skipped_rows, 
        parse_dates=True, 
        header=0, 
        names=header).drop(labels='Keine Ahnung', axis=1
    )


def load_data():
    """
    merges all dataframes from avaliable csv files
    """
    df = pd.DataFrame(columns=header).drop(labels='Keine Ahnung', axis=1)

    csv_files = []
    substrings = ["Umsatzauskunft_KtoNr0910387433", ".csv"]
    counter = 0
    for file in os.listdir():
        if substrings[0] in file and substrings[1] in file:
            df_aux = load_csv_as_df(file)
            if df_aux is not None:
                csv_files.append(file)
                df = pd.concat([df, df_aux])
                counter += 1

    print(f'Include {counter} files into data:')
    for csv in csv_files:
        print(f'  Included {csv}')
    print()
    df.drop_duplicates(subset=header.remove("Keine Ahnung"), inplace=True)

    return df


def filter_rent_time_for_month(df, month, year):
    """
    returns lines, where rent for specific month and year is payed typically
    """

    days_before = 7
    days_after = 20

    date_string = f'1.{month}.{year}'

    date_beg = pd.to_datetime(date_string, format='%d.%m.%Y')
    date_beg -= datetime.timedelta(days=days_before)
    date_end = pd.to_datetime(date_string, format='%d.%m.%Y')
    date_end += datetime.timedelta(days=days_after)

    return (df.date_booking >= date_beg) & (df.date_booking <= date_end)


def filter_quarter_of_year(df, quarter, year):
    """
    returns lines of specific quarter of a year
    """

    month_beg = (quarter-1) * 3 + 1

    date_string_beg = f'1.{month_beg}.{year}'
    date_string_end = f'1.{(month_beg + 3)%12}.{year + (0 if quarter != 4 else 1)}'

    date_beg = pd.to_datetime(date_string_beg, format='%d.%m.%Y')
    date_end = pd.to_datetime(date_string_end, format='%d.%m.%Y')
    date_end -= datetime.timedelta(days=1)

    return (df.date_booking >= date_beg) & (df.date_booking <= date_end)


def rent_payment_by_inhabitant(inhabitants, month, year):
    """
    returns dict: rent payed by each inhabitants in specific month and year
    """
    
    global volume

    # mask for lines representing rent payments
    #rent = volume.detail.str.lower().str.find('miet') >= 0
    right_amount = (volume.amount > 300) & (volume.amount < 900)

    rent_payment = {}
    for inhabitant in inhabitants:
        is_inhabitant = volume.orderer.str.lower().str.find(inhabitant.lower()) >=0
        rent_payment[inhabitant] = volume[
                is_inhabitant &
                filter_rent_time_for_month(volume, month, year) & 
                right_amount
            ].amount.sum()
    return rent_payment
    

def persistent_outgoing_per_quarter(receiver, col_dict, quarter, year):
    """
    returns sum of persistent outgoings of one type (search string) for a quarter and year
    """

    global volume

    filter_quarter = filter_quarter_of_year(volume, quarter, year)
    if receiver == "Prager":
        filter_quarter = filter_rent_time_for_month(volume, (quarter-1)*3+1 , year) | \
            filter_rent_time_for_month(volume, (quarter-1)*3+2 , year) | \
            filter_rent_time_for_month(volume, (quarter-1)*3+3 , year)

    for col in col_dict:
        filter_quarter = filter_quarter & (volume[col].str.lower().str.find(col_dict[col].lower()) >= 0)
    return volume[filter_quarter].amount.sum()


def print_rent_payments(dict_payment_by_inhabitant):
    print(f'Mieten für {month:02}.{year}')
    sum = 0
    for inh in dict_payment_by_inhabitant:
        if dict_rpbi[inh] != 0: print(f'  {inh}: {dict_rpbi[inh]:#.2f} EUR')
        sum += dict_rpbi[inh]
    print(f'  Summe: {sum:#.2f} EUR')
    print()


def print_persistent_outgoing_of_quarter(filter_dict, quarter, year):
    print(f'Ständige Ausgänge in Quartal {quarter} von {year}:')
    sum = 0
    for receiver in filter_dict:
        amount = persistent_outgoing_per_quarter(receiver, filter_dict[receiver], quarter, year)
        sum += amount
        print(f'  {receiver}: {amount:.2f} EUR')
    print(f'  Summe: {sum:.2f} EUR')
    print()


def clean_data():
    volume.amount = volume.amount.str.extract(r'([-,0-9]*)')
    volume.amount = volume.amount.str.replace('.', '', regex=False).str.replace(',', '.', regex=False).astype(float)

    volume.balance = volume.balance.str.extract(r'([-,.0-9]*)')
    volume.balance = volume.balance.str.replace('.', '', regex=False).str.replace(',', '.', regex=False).astype(float)

    volume.date_booking = pd.to_datetime(volume.date_booking, format='%d.%m.%Y')
    volume.date_value = pd.to_datetime(volume.date_value, format='%d.%m.%Y')


# ----------------------------------------------------------------------------
# global variables

header = [
    "date_booking",
    "date_value",
    "volume_kind", 
    "detail", 
    "orderer", 
    "receiver", 
    "amount", 
    "balance", 
    "Keine Ahnung"
]

inhabitants = [
    'Thomas Vogg', 
    'Carl-Maria Stracke', 
    'Felicia Wiehler', 
    'Engels Teresa', 
    'Florian Duffe', 
    'Mara Pollak', 
    'Sahra Al-Yassin',
    'Natascha Reichert'
]

persistent_outgoings_dict = {
    "Stadtwerke":{
        "receiver":"swm"}, 
    "M-Net":{
        "receiver":"m-net"},
    "Rundfunkgebühr":{
        "receiver":"rundfunk"},
    "Postbank":{
        "volume_kind":"zinsen"},
    "Prager":{
        "receiver":"liegenschaftsverwaltung", "detail":"miete"}
}



# ----------------------------------------------------------------------------
# load and clean data

volume = load_data()
clean_data()
volume.to_csv('saved.csv')


# ----------------------------------------------------------------------------
# main

# example for rents
year = 2021
for month in range(1,8):
    dict_rpbi = rent_payment_by_inhabitant(inhabitants, month, year)
    print_rent_payments(dict_rpbi)


# ständige ausaben quartal
# datum | betrag | name | Verwendungszweck
print_persistent_outgoing_of_quarter(persistent_outgoings_dict, 1, 2021)
print_persistent_outgoing_of_quarter(persistent_outgoings_dict, 2, 2021)
print_persistent_outgoing_of_quarter(persistent_outgoings_dict, 3, 2021)
print_persistent_outgoing_of_quarter(persistent_outgoings_dict, 4, 2021)

# ausserordentliche ausaben
# datum | betrag | name | Verwendungszweck


# eingänge
# ständig
# ausserordentlich


