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

    params = {
        'TableName': table
    }

    if path_parameters and path_parameters['todoId']:
        data = dynamo.get_item(
            **params,
            Key={
                'id': int(path_parameters['todoId'])
            }
        )
    else:
        data = dynamo.scan(params)

    print({
        'message': 'Records found',
        'data': json.dumps(data)
    })

    return response(200, data)
