from flask import Flask, render_template
from src.ip import get_ip_address, get_location
import socket
from src.logs import logger

app = Flask(__name__)


@app.route("/")
def index():
    try:
        ip_address = get_ip_address()
        if ip_address is None or ip_address == "":
            error_message = "Unable to obtain IPv4 address"
            logger.error(error_message)
            return render_template("index.html", error_message=error_message)
        location = get_location(ip_address)
        if location == "None, None, None":
            error_message = "Unable to obtain location information"
            # Handle the error condition
            logger.error(
                "Error obtaining location information for IP address: %s", ip_address
            )
            return render_template(
                "index.html", error_message=error_message, ip_address=ip_address
            )
        logger.info("IP Address: %s Location: %s", ip_address, location)
        return render_template("index.html", ip_address=ip_address, location=location)
    except socket.error as exception:
        error_message = "There was an error obtaining your IP address."
        logger.exception(exception)
        return render_template("index.html", error_message=error_message)
    except Exception as exception:
        error_message = "There was an error obtaining your IP address."
        logger.exception(exception)
        return render_template("index.html", error_message=error_message)


if __name__ == "__main__":
    # app.run(host='0.0.0.0', port=5001, debug=True)
    app.run()
