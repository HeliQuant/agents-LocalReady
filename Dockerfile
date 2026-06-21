# agents-LocalReady — your local HeliQuant engine, containerized.
FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends git curl build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
# Pull the firm (public repo). Rebuild the image (--no-cache) to update to the latest main.
RUN git clone --depth 1 https://github.com/HeliQuant/agents.git firm

WORKDIR /opt/firm
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir -e . \
    && pip install --no-cache-dir "uvicorn[standard]"

COPY start.sh /opt/start.sh
RUN chmod +x /opt/start.sh

EXPOSE 8000
CMD ["/opt/start.sh"]
