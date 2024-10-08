FROM python:3.13-slim

WORKDIR /usr/app

COPY app/requirements.txt ./

RUN pip install -r requirements.txt

COPY ./app/ .

EXPOSE 5000

CMD ["python", "/usr/app/app.py"]
