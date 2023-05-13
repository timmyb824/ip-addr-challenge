import logging
import logging.config
import os

logging.config.fileConfig(
    os.path.realpath(os.path.join(os.path.dirname(__file__), "")) + "/logs/logging.ini",
    disable_existing_loggers=False,
)

# Get the logger specified in the file
logger = logging.getLogger()
