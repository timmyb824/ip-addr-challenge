import ipaddress
import os

import requests
from dotenv import load_dotenv
from flask import request

from src.logs.logger import logger

# Load environment variables from .env file
load_dotenv()


def get_location(ip_address: str) -> str | None:
    # sourcery skip: extract-method, remove-redundant-fstring, remove-unnecessary-else
    api_key = os.getenv("API_KEY")
    if not api_key:
        logger.error("API_KEY not set in .env file")
        return None

    try:
        response = requests.get(
            f"https://api.ipgeolocation.io/ipgeo",
            params={"apiKey": api_key, "ip": ip_address},
            timeout=15,
        )

        # Log the status code and response content for debugging
        logger.debug("Received status code: %s", response.status_code)
        logger.debug("Received response content: %s", response.content.decode("utf-8"))

        if response.status_code != 200:
            logger.error("Received non-OK status code: %s", response.status_code)
            return None

        data = response.json()
        city = data.get("city")
        region = data.get("state_prov")
        country = data.get("country_code2")

        if city and region and country:
            return f"{city}, {region}, {country}"
        else:
            logger.warning("Incomplete location data for IP %s: %s", ip_address, data)
            return None

    except requests.exceptions.RequestException as exception:
        logger.error(
            "Error while fetching location for IP Address: %s (%s)",
            ip_address,
            exception,
        )
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
