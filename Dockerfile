FROM python:3.10.9-alpine3.17

RUN apk update --no-cache && apk upgrade --no-cache

RUN apk upgrade libcrypto3
RUN apk upgrade libssl3

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5001

RUN chmod +x ./configs/entrypoint.sh

ENTRYPOINT ["sh", "./configs/entrypoint.sh"]
