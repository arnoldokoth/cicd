FROM python:3.5-alpine

RUN mkdir -p /usr/src/sample_app/
COPY . /usr/src/sample_app/

WORKDIR /usr/src/sample_app/
RUN pip install -r requirements.txt

ENTRYPOINT ["python", "app/app.py"]
EXPOSE 5000
