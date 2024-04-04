FROM python:3.11-alpine
WORKDIR /FlaskApp/
RUN python -m venv /FlaskApp/venv
ENV PATH="/FlaskApp/venv/bin:$PATH"
COPY ./src /FlaskApp
RUN pip install -Ur /FlaskApp/requirements.txt
CMD ["python", "/FlaskApp/app.py"]
