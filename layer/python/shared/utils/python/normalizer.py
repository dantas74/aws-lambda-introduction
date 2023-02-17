import base64
import json


def normalize_event(event):
    body = event['body']

    return {
        'method': event['requestContext']['http']['method'],
        'data': json.loads(base64.b64decode(body)) if event['body'] else {}
    }
