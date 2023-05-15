#!/bin/bash
exec gunicorn --config ./configs/gunicorn.config.py src.main:app
