ARG PYTHON_VERSION=3.13.0a4
FROM python:${PYTHON_VERSION}-alpine3.19 as base

# Evitar que o python crie arquivos de bytecode pyc durante compilação.
ENV PYTHONDONTWRITEBYTECODE=1

# Manter buffer de output (default,err).
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Best-practices - rodar como usuario least-minimum-privileges.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/dev/null" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# Best-practices - montar cache separado do pip para os builds
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements.txt,target=requirements.txt \
    python -m pip install -r requirements.txt

# Setar o user criado como usuario dos processos de app.
USER appuser

# Copiar o código python para o container.
COPY counter-app.py .

# Deixar porta 8080/tcp em listen no container para a app
EXPOSE 8080

# Rodar o http server wsgi python gunicorn com logs habilitados
CMD ["gunicorn", "counter-app:app", "--bind", "0.0.0.0:8080", "--access-logfile", "-", "--error-logfile", "-"]
