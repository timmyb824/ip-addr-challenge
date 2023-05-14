import requests
import ipaddress
from flask import request
from src.logs import logger


def get_location(ip_address: str) -> str | None:
    try:
        response = requests.get(f"https://ipapi.co/{ip_address}/json/").json()
        city = response.get("city")
        region = response.get("region")
        country = response.get("country_name")
        return f"{city}, {region}, {country}"
    except requests.exceptions.ConnectionError as exception:
        logger.error("Connection Error for IP Address: %s (%s)", ip_address, exception)
        return None


def get_ip_address() -> str | None:
    # sourcery skip: use-contextlib-suppress, use-named-expression
    try:
        ip_address = request.headers.get("X-Forwarded-For", "").split(",")[0].strip()
        if ip_address and ipaddress.ip_address(ip_address).version == 4:
            return ip_address
    except ValueError:
        # The IP address is not a valid IPv4 or IPv6 address
        pass

    try:
        ip_address = request.headers.get("X-Real-IP", "").strip()
        if ip_address and ipaddress.ip_address(ip_address).version == 4:
            return ip_address
    except ValueError:
        # The IP address is not a valid IPv4 or IPv6 address
        pass

    # Fall back to remote_addr
    return request.remote_addr
