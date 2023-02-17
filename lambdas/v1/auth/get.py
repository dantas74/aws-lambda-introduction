from shared.decorators.is_authenticated import is_authenticated
from shared.utils.python.reponse import response


@is_authenticated
def handler(event, _context):
    return response(200, {
        'message': f'Your user is {event["token"]["username"]} and email is {event["token"]["email"]}'
    })
