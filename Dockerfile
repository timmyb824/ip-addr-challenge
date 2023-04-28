FROM python:3.10.9-alpine3.17

RUN apk update --no-cache && apk upgrade --no-cache

RUN apk upgrade libcrypto3
RUN apk upgrade libssl3

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["gunicorn", "src.main:app", "--host", "0.0.0.0", "--port", "5001"]