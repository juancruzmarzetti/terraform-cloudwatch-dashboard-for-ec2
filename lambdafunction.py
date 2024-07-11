#!/usr/bin/python3.6
import urllib3
import json
http = urllib3.PoolManager()
def lambda_handler(event, context):
    url = "your-slack-app-webhook-url"
    msg = {
        "text":"App´s CPUUtilization is higher than 70% :fire:"
    }
    encoded_msg = json.dumps(msg).encode('utf-8')
    resp = http.request('POST',url, body=encoded_msg)