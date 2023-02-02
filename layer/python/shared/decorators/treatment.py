import json
import os

from shared.utils.python.reponse import response


def treatment(function):
    def wrapper(event, context):
        if os.getenv('DEBUG', False) == 'true':
            print({
                'message': 'Received event',
                'data': json.dumps(event)
            })

        try:
            return function(event, context)

        except Exception as exc:
            print(exc)
            return response(500, {
                'message': 'Something went wrong'
            })

    return wrapper
