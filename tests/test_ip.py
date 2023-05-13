import pytest
import requests
from unittest.mock import patch
from src.ip import get_location, get_ip_address


def test_get_location_valid_ip():
    ip_address = "192.168.0.1"
    expected_result = "City, Region, Country"
    with patch("requests.get") as mock_get:
        mock_get.return_value.json.return_value = {
            "city": "City",
            "region": "Region",
            "country_name": "Country",
        }
        result = get_location(ip_address)
        assert result == expected_result


def test_get_location_invalid_ip():
    ip_address = "invalid_ip"
    expected_result = None
    with patch("requests.get") as mock_get:
        mock_get.side_effect = requests.exceptions.ConnectionError
        result = get_location(ip_address)
        assert result == expected_result


# TODO:  Fix these 2 tests
# def test_get_ip_address_with_header():
#     with patch("flask.request.headers.get") as mock_get:
#         mock_get.return_value = "192.168.0.1:1234"
#         result = get_ip_address()
#         assert result == "192.168.0.1"

# def test_get_ip_address_without_header():
#     with patch("flask.request.headers.get") as mock_get, \
#          patch("flask.request.remote_addr") as mock_remote_addr:
#         mock_get.return_value = ""
#         mock_remote_addr.return_value = "192.168.0.1"
#         result = get_ip_address()
#         assert result == "192.168.0.1"
