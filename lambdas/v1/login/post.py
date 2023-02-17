import jwt

from shared.utils.python.normalizer import normalize_event
from shared.utils.python.reponse import response


def handler(event, _context):
    normalized_body = normalize_event(event)['data']

    if normalized_body['username'] == 'matheus-dr' and normalized_body['password'] == '123mudei':
        return response(200, {
            'token': f'Bearer {jwt.encode({"username": "matheus-dr", "email": "matheus-dr@proton.me"}, "1234")}'
        })

    else:
        return response(401, 'Wrong credentials')
