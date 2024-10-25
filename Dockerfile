FROM python:3.11.8-alpine

ENV PYTHONUNBUFFERED=1

WORKDIR /code

COPY ./requirements.txt .

RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/UTC /etc/localtime && \
    echo "UTC" > /etc/timezone && \
    pip install --no-cache-dir --upgrade -r requirements.txt

COPY . .

RUN chmod +x main.py

CMD ["sh", "-c", "alembic upgrade head && python3 main.py"]