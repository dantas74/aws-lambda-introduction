import jwt

from shared.utils.python.reponse import response


def is_authenticated(function):
    def wrapper(event, context):
        try:
            print(event)
            decoded_user = jwt.decode(event['headers']['authorization'].replace('Bearer ', ''), '1234', 'HS256')

            event['token'] = decoded_user

            try:
                return function(event, context)
            except Exception as exc:
                print(exc)
                return response(500, 'Something went wrong')

        except KeyError:
            return response(401, {
                'message': 'You are missing authentication'
            })

    return wrapper
