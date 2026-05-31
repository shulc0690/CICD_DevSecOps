# Dockerfile
# Використовуємо офіційний образ Python
FROM python:3.11-slim

# Встановлюємо робочий каталог у контейнері
WORKDIR /app

# Копіюємо файл requirements.txt з кореневого каталогу
# і встановлюємо залежності
COPY requirements.txt .
RUN pip install -r requirements.txt

# Копіюємо код додатка в робочий каталог
# Використовуємо COPY . . щоб скопіювати весь поточний каталог
# Це враховує, що ваші файли test_app.py та app.py знаходяться в корені
COPY . .

# Визначаємо змінні середовища для Flask
ENV FLASK_APP=app.py
ENV FLASK_HOST=0.0.0.0
ENV FLASK_PORT=5000

# Відкриваємо порт 5000
EXPOSE 5000

# Запускаємо додаток
CMD ["python", "app.py"]