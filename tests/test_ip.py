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
        self.assertEqual(result, "None, None, None")

    @patch("src.ip.requests.get")
    @patch("src.ip.os.getenv")
    def test_api_error(self, mock_getenv, mock_get):
        mock_getenv.return_value = "fake_api_key"
        mock_response = mock_get.return_value
        mock_response.status_code = 400
        mock_response.json.return_value = {}

        result = src.ip.get_location("8.8.8.8")
        self.assertEquals = "None, None, None"

    @patch("src.ip.os.getenv")
    def test_no_api_key(self, mock_getenv):
        mock_getenv.return_value = "None, None, None"
        result = src.ip.get_location("8.8.8.8")
        self.assertEquals = "None, None, None"
