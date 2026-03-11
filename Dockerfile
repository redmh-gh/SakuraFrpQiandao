FROM python:3.11-slim

WORKDIR /app

# Install Chrome and base tools (based on workflow)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        unzip \
        wget \
        gnupg \
        ca-certificates \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-linux.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
        > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir webdriver-manager chromedriver-binary-auto

COPY . .

ENV CI=true \
    HEADLESS=true

CMD ["python", "main.py"]
