#!/usr/bin/python3

import pandas as pd

file_path = "/home/tomo/Dropbox/Markdown/Finanzen/ausgaben.csv"
df_data = pd.read_csv(file_path, delimiter=';')

print(df_data)
