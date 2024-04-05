FROM python:3.11-alpine
WORKDIR /FlaskApp/
ARG MY_SEC
ENV MY_SECRET=$MY_SEC
RUN python -m venv /FlaskApp/venv
ENV PATH="/FlaskApp/venv/bin:$PATH"
COPY ./src /FlaskApp
RUN pip install -Ur /FlaskApp/requirements.txt
CMD ["python", "/FlaskApp/app.py"]
