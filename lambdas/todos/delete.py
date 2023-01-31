import json
import os

import boto3

from shared.decorators.treatment import treatment
from shared.utils.python.normalizer import normalize_event
from shared.utils.python.reponse import response

dynamo = boto3.client('dynamodb')
ssm = boto3.client('ssm')


@treatment
def handler(event):
    table = ssm.get_parameter(Name=os.getenv('TABLE'))['Parameter']['Value']
    path_parameters = normalize_event(event)['path_parameters']

    todo_id = path_parameters['todoId']

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
