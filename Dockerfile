FROM python:3.12-slim

RUN pip install --no-cache-dir poetry
RUN apt-get update && apt-get install -y make
RUN apt install -y postgresql-client

WORKDIR /app

COPY pyproject.toml poetry.lock* /app/
RUN poetry config virtualenvs.create false \
 && poetry install --no-root --no-interaction --no-ansi

COPY . /app

CMD ["bash", "-c", "./wait-for-it.sh db:$POSTGRES_PORT && make migrate && make run"]