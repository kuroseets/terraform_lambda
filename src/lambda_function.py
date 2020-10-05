import os
import json
import urllib.request

WEBHOOK_URL = os.environ['SLACK_WEBHOOK_URL']
CHANNEL_NAME = os.environ['CHANNEL_NAME']

def lambda_handler(event, context):

  send_data = {
    'channel': CHANNEL_NAME,
    'username': 'Test Lambda',
    'icon_emoji': ':smile:',
    'text': 'test'
  }

  send_text = ('payload=' + json.dumps(send_data)).encode('utf-8')
  request = urllib.request.Request(
    WEBHOOK_URL,
    data=send_text,
    method='POST'
  )

  with urllib.request.urlopen(request) as response:
    response_body = response.read().decode('utf-8')

  return response_body

if __name__ == '__main__':
  pass
