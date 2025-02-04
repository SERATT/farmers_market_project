import requests
import time

while True:
	payload = {"username": "teamhadmin", "password": "TryMe"}
	r = requests.post("https://farmers-market-35xe.onrender.com/farmer-market-api/auth/signin", data=payload)
	if (r.status_code == 401): 
		time.sleep(30)

