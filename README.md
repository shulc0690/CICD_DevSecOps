# CICD_DevSecOps

Повний комплексний проєкт CI/CD pipeline з етапами безпеки (DevSecOps) для Python-додатка на Flask.

## 📋 Про проєкт

Проєкт демонструє сучасний підхід до розробки та розгортання безпечного програмного забезпечення через GitHub Actions. Включає:

- **Python Flask Application** - простий веб-додаток з демонстраційними маршрутами
- **Docker контейнеризацію** - завантаження образів в GitHub Container Registry (GHCR)
- **Автоматизований CI/CD pipeline** - з сім етапами безпеки та тестування
- **DevSecOps практики** - сканування на вразливості на кожному етапі

## 🏗️ Архітектура проєкту

```
CICD_DevSecOps/
├── app.py                 # Flask додаток
├── test_app.py           # Unit тести
├── requirements.txt      # Python залежності
├── Dockerfile            # Docker конфіг для контейнеризації
├── .github/workflows/    # GitHub Actions workflows
│   └── cicd-pipeline.yml # Основний pipeline
└── README.md            # Цей файл
```

## 🔐 CI/CD Pipeline (7 етапів)

### 1️⃣ **Secret Scanning** (secret-scan)
Сканування репозиторію на випадково скомітлені секрети (ключі API, паролі тощо).
- Інструмент: **TruffleHog**
- Статус: ❌ Не може бути неуспішним (allow_failure: false)

### 2️⃣ **SAST аналіз** (Static Application Security Testing)
Статичний аналіз вихідного коду на вразливості.
- Інструменти: **Bandit** (security), **Pylint** (code quality)
- Виявляє: SQL injection, eval(), binding до всіх інтерфейсів
- Статус: ❌ Не може бути неуспішним

### 3️⃣ **Unit тести** (test)
Запуск автоматичних тестів додатка з вимірюванням покриття коду.
- Інструмент: **pytest**
- Залежить від: SAST
- Статус: ❌ Не може бути неуспішним
- Вихід: Coverage звіт (завантажується в Codecov)

### 4️⃣ **Docker Build** (build)
Створення та завантаження Docker образу до GHCR.
- Технологія: **Docker Buildx** з кешуванням (GitHub Actions Cache)
- Tags: 
  - `main` (гілка)
  - `sha-<commit>` (commit хеш)
  - `latest` (тільки для main гілки)
- Залежить від: Unit тестів
- Статус: ❌ Не може бути неуспішним

### 5️⃣ **SCA - Dependency Scanning** (Software Composition Analysis)
Аналіз залежностей на вірусні або вразливі пакети.
- Інструменти: 
  - **Safety** - проверка Python пакетів
  - **pip-audit** - аудит залежностей
- Залежить від: Docker Build
- Статус: ⚠️ Може бути неуспішним (allow_failure: true)

### 6️⃣ **Container Scanning** (SCA)
Сканування Docker образу на вразливості операційної системи та пакетів.
- Інструмент: **Trivy** (aquasecurity)
- Форматрезультатів: SARIF для GitHub Security
- Залежить від: Docker Build
- Статус: ⚠️ Може бути неуспішним

### 7️⃣ **Deploy + DAST** (Розгортання та динамічне тестування)
Розгортання приложення та динамічний аналіз безпеки.

**Deploy:**
- Завантаження Docker образу
- Запуск контейнера на порті 5000
- Health check через curl
- Залежить від: SCA та Container Scanning

**DAST (Dynamic Application Security Testing):**
- Інструмент: **OWASP ZAP** (Zaproxy)
- Перевіряє запущене приложення на вразливості (SQL injection, XSS, тощо)
- Залежить від: Docker Build (запускає образ самостійно)

## 🚀 Як запустити pipeline

### Автоматично (при push)
```bash
git push origin main
```
Pipeline запуститься автоматично на GitHub Actions.

### Вручну (через GitHub UI)
1. GitHub репозиторій → **Actions**
2. Обрати **CI/CD DevSecOps Pipeline**
3. **Run workflow** → Вибрати гілку

## 📊 Моніторинг та звіти

### GitHub Security Tab
Pipeline завантажує результати в GitHub Security:
- Secret scanning результати
- SAST аналіз
- Container сканування (Trivy SARIF)
- Залежності та вразливості

### Codecov
Звіти покриття коду та аналітика:
- Upload на: https://codecov.io

## 🔧 Конфігурація

### Змінні середовища (Docker)
```dockerfile
FLASK_HOST=0.0.0.0      # Host для слухання
FLASK_PORT=5000         # Port
```

### GitHub Secrets (якщо потрібні)
Поточно використовує `GITHUB_TOKEN` (автоматичний).

## 📝 Основні файли

### `app.py`
Flask приложение з маршрутами:
- `GET /` - Hello World
- `GET /execute?code=...` - Виконання літеральних виразів (демонстрація SAST)

### `test_app.py`
Unit тести для Flask routes.

### `requirements.txt`
Python залежності:
- flask
- (інші...)

### `Dockerfile`
Multi-stage Docker образ на базі `python:3.11-slim`.

## 🛡️ DevSecOps Best Practices

✅ **Implemented:**
- ❌ Strict gate policies (всі критичні завдання не можуть бути неуспішними)
- 🔍 Багатошарове сканування (код → контейнер → runtime)
- 📦 Кешування для оптимізації часу збірки
- 🔐 Автентифікація через GITHUB_TOKEN
- 📊 SARIF звіти для GitHub Security integration
- 🧪 Unit тести з вимірюванням покриття

## 📞 Посилання

- [GitHub Actions Документація](https://docs.github.com/en/actions)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [OWASP DevSecOps](https://owasp.org/www-community/DevSecOps)
- [Trivy Scanner](https://github.com/aquasecurity/trivy)
- [OWASP ZAP](https://www.zaproxy.org/)

## 📄 Ліцензія

MIT

---

**Автор:** GoIT CI/CD DevSecOps Project  
**Статус:** ✅ Active