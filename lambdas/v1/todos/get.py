from shared.utils.python.reponse import response


def handler(event, _context):
    return response(200, 'This is get from todos')
