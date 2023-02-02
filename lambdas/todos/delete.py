import json
import os

import boto3

from shared.decorators.treatment import treatment
from shared.utils.python.normalizer import normalize_event
from shared.utils.python.reponse import response

dynamo = boto3.client('dynamodb')
ssm = boto3.client('ssm')


@treatment
def handler(event, _context):
    table = ssm.get_parameter(Name=os.getenv('TABLE'))['Parameter']['Value']

    normalized_event = normalize_event(event)
    data = normalized_event['data']

    todo_id = data['todoId']

    params = {
        'TableName': table,
        'Key': {
            'id': int(todo_id)
        }
    }

    dynamo.delete_item(params)

    print({
        'message': 'Records has been deleted',
        'data': json.dumps(params)
    })

    return response(200, f'Record {todo_id} has been deleted')
