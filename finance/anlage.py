import math as m

def anlage(start_kapital, zins_pa, laufzeit, einzahlung_monat):
    zins_monat = (zins_pa)**(1/12)
    print(f"zinzen pro monat: {zins_monat}")
    einlage = start_kapital
    for monat in range(laufzeit * 12 + 1):
        if monat%12 == 0: print(f"jahr {monat//12}: {einlage}, gesamteinzahlungen: {monat * einzahlung_monat}")
        einlage = (einlage + einzahlung_monat) * (zins_monat) 

start_kapital = 15000
zins  = 1.06
jahre = 20
einzahlung = 50

#anlage(start_kapital, zins, jahre, einzahlung)
#anlage(2000, 1.06, 37, 25)
#anlage(0, 1.06, 7, 25)
anlage(15000, 1.06, 25, 200)
