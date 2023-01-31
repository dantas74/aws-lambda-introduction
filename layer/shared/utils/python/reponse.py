import json


def response(status, body):
    return {
        'statusCode': status,
        'body': json.dumps(body),
        'headers': {
            'Content-Type': 'application/json'
        }
    }
