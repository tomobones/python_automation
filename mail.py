#!/usr/bin/python3

import smtplib, ssl

smtp_server = "mail.gmx.net"
port = 465
sender_email = "thomas.vogg@gmx.de"
receiver_email = "thomas.vogg@posteo.de"
password = input("Type your password and press enter: ")
message = """
Subject: Test

This message is sent from Python."""

context = ssl.create_default_context()
with smtplib.SMTP(smtp_server, port) as server:
    server.ehlo()  # Can be omitted
    server.starttls(context=context)
    server.ehlo()  # Can be omitted
    server.login(sender_email, password)
    server.sendmail(sender_email, receiver_email, message)
