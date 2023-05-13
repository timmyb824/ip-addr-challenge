import requests
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
    try:
        ip_address = (
            request.headers.get("X-Forwarded-For", "").split(",")[0].split(":")[-1]
        )
    except KeyError:
        ip_address = request.remote_addr
    return ip_address
