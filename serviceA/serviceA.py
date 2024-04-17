import collections
from flask import Flask, jsonify
import requests
import json
import time
from requests import get
from collections import deque
import threading
app = Flask(__name__)


my_last_10m = collections.deque()        
average = 0

def get_data():
    global value_10
    while True:
            resp = requests.post('https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD') 
            data = json.loads(resp.text)
            value_10 = data['USD']
            #print(value_10)
            my_last_10m.append(value_10)
            if len(my_last_10m) > 60:
                my_last_10m.popleft()
            time.sleep(10)                                                                                   
            
            
            

@app.route('/')
def bitcoin():
    global value_10
    return jsonify({
        'current_value': value_10,
        'average_over_last_10m': sum(my_last_10m) / len(my_last_10m),
        'number_of_elements': len(my_last_10m)
    })

if __name__ == '__main__':

    data_fetch_thread = threading.Thread(target=get_data)
    data_fetch_thread.daemon = True
    data_fetch_thread.start()
 
    app.run(host='0.0.0.0', port = 5000)