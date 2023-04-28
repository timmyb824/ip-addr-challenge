#!/bin/bash
exec gunicorn --config ./configs/gunicorn_config.py src.main:app