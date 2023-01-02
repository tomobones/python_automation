#!/usr/bin/python3

import datetime as dt

# adjust these numbers, eg to control, when first day wrt to this day begins
number_days_from_now = -2
number_weeks_each_row = 1
number_months = 60
names = ["Tomo", "Mara", "Carli", "Flow", "Natascha", "Cenk", "Christine"]

start = dt.datetime.now() + dt.timedelta(days = number_days_from_now)
start_and_a_week = start + dt.timedelta(days = (number_weeks_each_row * 7) - 1)
one_week = dt.timedelta(days = number_weeks_each_row * 7)

print("Datum; Name; Check; Datum; Name; Check;")

index_end = int(number_months/2)
for i in range(0, index_end ):
    start_date_1 = start + i*one_week
    end_date_1 = start_and_a_week + i*one_week
    start_date_2 = start + (i + index_end) * one_week
    end_date_2 = start_and_a_week + (i + index_end) * one_week

    print(str(start_date_1.strftime("%d.%m.%Y"))+" - "+str(end_date_1.strftime("%d.%m.%Y")), end=';')
    print(names[i % len(names)], end=';')
    print(end=';')
    print(str(start_date_2.strftime("%d.%m.%Y"))+" - "+str(end_date_2.strftime("%d.%m.%Y")), end=';')
    print(names[(i + index_end) % len(names)], end = ';')
    print(end=';\n')



