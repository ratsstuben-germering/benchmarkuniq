
FROM python:3.13-slim

WORKDIR /app

COPY app/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

