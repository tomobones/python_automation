#!/usr/bin/python3

import requests
import cloudscraper
import time

headers = {
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:97.0) Gecko/20100101 Firefox/97.0",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.5",
        "Upgrade-Insecure-Requests": "1",
        "Sec-Fetch-Dest": "document",
        "Sec-Fetch-Mode": "navigate",
        "Sec-Fetch-Site": "none",
        "Sec-Fetch-User": "?1",
        "Cache-Control": "max-age=0"}

def check_page_2(url_string, exclude_string):
    response = requests.get(url_string, headers=headers)
    html = response.text
    code = response.status_code
    return
    if response.text.find(exclude_string) != -1:
        pass
        #print(f"PS5 auf {url_string} nicht verfügbar.")
    else: 
        print(f"PS5 ist auf {url_string} verfügbar.")

def check_page_1(url_string, exclude_string):
    response = cloudscraper.create_scraper().get(url_string)
    html = response.text
    code = response.status_code
    if html.find(exclude_string) != -1:
        pass
        #print(f"PS5 auf {url_string} nicht verfügbar.")
    else: 
        print(f"PS5 ist auf {url_string} verfügbar.")

while True:
    print(end=".", flush=True)
    check_page_1("https://www.mueller.de/multi-media/playstation-5/", "ausverkauft")
    check_page_1("https://www.amazon.de/d/B09QG2JZYS", "Derzeit")
    #check_page_1("https://ps5.expert.de/Themenwelten/Sony-PS5.html", "Leider")
    #check_page_1("https://www.gameware.at/info/space/PlayStation+5", "momentan")
    time.sleep(10)




# _________________________________________________
# geht nicht

#check_page_2("https://www.mediamarkt.de/de/product/_sony-playstation%C2%AE5-2661938.html", "bald")
#check_page_2("https://www.saturn.de/de/product/_sony-playstation%C2%AE5-2661938.html?__cf_chl_tk=sAVEvrdK5bCLYaEllo.YNRx", "bald")
#check_page_2("https://www.otto.de/technik/gaming/playstation/ps5/", "leider")
#check_page_2("https://www.smythstoys.com/de/de-de/gaming/playstation/playstation-5-konsole-und-zubehör/playstation-5-konsole/p/195650", "derzeit")





