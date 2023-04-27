from flask import Flask, render_template
from src.ip import get_ip_address
import socket

app = Flask(__name__)

@app.route('/')
def index():
    try:
        ip_address = get_ip_address()
        return render_template('index.html', ip_address=ip_address)
    except socket.error:
        error_message = "There was an error obtaining your IP address."
        return render_template('index.html', error_message=error_message)

if __name__ == '__main__':
    # app.run(host='0.0.0.0', port=5001, debug=True)
    app.run()
