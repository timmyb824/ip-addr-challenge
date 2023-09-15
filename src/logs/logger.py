import logging
import logging.config
import os

LOGGING_INI_PATH = os.path.join(os.path.dirname(__file__), "logging.ini")
LOG_FILE_PATH = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "logs", "app.json"
)

logging.config.fileConfig(LOGGING_INI_PATH, defaults={"logfilename": LOG_FILE_PATH})

# Get the logger specified in the file
logger = logging.getLogger()
