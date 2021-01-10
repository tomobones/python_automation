#!/usr/bin/python3

import datetime as dt

# adjust this number to control, when first day wrt to this day begins
number_days_from_now = 8

start = dt.datetime.now() + dt.timedelta(days = number_days_from_now)
start_and_a_week = start + dt.timedelta(days = 6)
one_week = dt.timedelta(days = 7)

print("Datum; Name; Check;")

for i in range(0,60):
    start_date = start + i*one_week
    end_date = start_and_a_week + i*one_week
    print(str(start_date.strftime("%d.%m.%Y"))+" - "+str(end_date.strftime("%d.%m.%Y"))+";")
