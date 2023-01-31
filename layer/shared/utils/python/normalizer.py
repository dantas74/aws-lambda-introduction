import json


def normalize_event(event):
    return {
        'method': event['requestContext']['http']['method'],
        'data': json.loads(event['body']) if event['body'] else {},
        'query_string': event['queryStringParameters'] or {},
        'path_params': event['pathParameters'] or {}
    }
