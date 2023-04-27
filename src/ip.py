from flask import request

def get_ip_address():
    try:
        ip_address = request.headers['X-Forwarded-For'].split(',')[0]
    except KeyError:
        ip_address = request.remote_addr
    return ip_address