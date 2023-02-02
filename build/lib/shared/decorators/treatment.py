import json
import os

from shared.utils.python.reponse import response


def treatment(function):
    def wrapper(event):
        if os.getenv('DEBUG', False) == 'True':
            print({
                'message': 'Received event',
                'data': json.dumps(event)
            })

        try:
            function(event)

        except Exception as exc:
            print(exc)
            return response(500, {
                'message': 'Something went wrong'
            })

    return wrapper
