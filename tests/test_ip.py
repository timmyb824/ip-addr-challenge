import logging
import unittest
from unittest.mock import patch

from werkzeug.wrappers import Request

import src.ip

# Initialize the logger to avoid "No handler found" warnings.
logging.basicConfig()


class TestGetLocation(unittest.TestCase):
    @patch("src.ip.requests.get")
    @patch("src.ip.os.getenv")
    def test_successful_location_retrieval(self, mock_getenv, mock_get):
        mock_getenv.return_value = "fake_api_key"
        mock_response = mock_get.return_value
        mock_response.status_code = 200
        mock_response.json.return_value = {
            "city": "Mountain View",
            "state_prov": "California",
            "country_code2": "US",
        }

        result = src.ip.get_location("8.8.8.8")
        self.assertEqual(result, "Mountain View, California, US")

    @patch("src.ip.requests.get")
    @patch("src.ip.os.getenv")
    def test_incomplete_data(self, mock_getenv, mock_get):
        mock_getenv.return_value = "fake_api_key"
        mock_response = mock_get.return_value
        mock_response.status_code = 200
        mock_response.json.return_value = {
            "city": None,
            "state_prov": "California",
            "country_code2": "US",
        }

        result = src.ip.get_location("8.8.8.8")
        self.assertIsNone(result)

    @patch("src.ip.requests.get")
    @patch("src.ip.os.getenv")
    def test_api_error(self, mock_getenv, mock_get):
        mock_getenv.return_value = "fake_api_key"
        mock_response = mock_get.return_value
        mock_response.status_code = 400
        mock_response.json.return_value = {}

        result = src.ip.get_location("8.8.8.8")
        self.assertIsNone(result)

    @patch("src.ip.os.getenv")
    def test_no_api_key(self, mock_getenv):
        mock_getenv.return_value = None
        result = src.ip.get_location("8.8.8.8")
        self.assertIsNone(result)


# TODO:  Fix these 2 tests
# class TestGetIpAddress(unittest.TestCase):

#     @patch('src.ip.request')
#     def test_x_forwarded_for_ipv4(self, mock_request):
#         mock_request.headers = {
#             "X-Forwarded-For": "192.168.1.1, 10.0.0.1"
#         }
#         result = src.ip.get_ip_address()
#         self.assertEqual(result, "192.168.1.1")

#     @patch('src.ip.request')
#     def test_x_real_ip_ipv4(self, mock_request):
#         mock_request.headers = {
#             "X-Real-IP": "192.168.1.2"
#         }
#         result = src.ip.get_ip_address()
#         self.assertEqual(result, "192.168.1.2")

#     @patch('src.ip.request')
#     def test_invalid_ipv4_address(self, mock_request):
#         mock_request.headers = {
#             "X-Real-IP": "999.999.999.999"
#         }
#         result = src.ip.get_ip_address()
#         self.assertIsNone(result)  # Should fall back to remote_addr, which is None

#     @patch('src.ip.request')
#     def test_fallback_to_remote_addr(self, mock_request):
#         mock_request.headers = {}
#         mock_request.remote_addr = "10.0.0.2"
#         result = src.ip.get_ip_address()
#         self.assertEqual(result, "10.0.0.2")

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
