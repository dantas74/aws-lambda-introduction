import datetime
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

    data = normalize_event(event)['data']

    params = {
        'TableName': table,
        'Item': {
            **data,
            'created_at': datetime.datetime.now()
        }
    }

    dynamo.put_item(params)

    print({
        'message': 'Records has been created',
        'data': json.dumps(params)
    })

    return response(201, f'Record {data.id} has been created')
