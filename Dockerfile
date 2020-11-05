# https://hub.docker.com/r/tiangolo/uvicorn-gunicorn/
FROM tiangolo/uvicorn-gunicorn:python3.8-slim

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

# install prod dependencies
RUN pip install --no-cache-dir fastapi
COPY ./app /app

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
CMD exec gunicorn --bind :$PORT --workers 4 --threads 8 --timeout 0 main:app