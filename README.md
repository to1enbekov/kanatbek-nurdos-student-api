# Kanatbek Nurdos — Student API (DevOps Midterm)

**Student:** Kanatbek Nurdos  
**Course:** DevOps Midterm  
**Project:** Spring Boot CRUD API + PostgreSQL + Docker + Jenkins

Project status: Main branch confirms PostgreSQL CRUD implementation.

## Quick start (Ubuntu / WSL)

```bash
cp .env.example .env
nano .env     # replace POSTGRES_PASSWORD with a strong value
chmod +x gradlew scripts/*.sh
./gradlew test
docker compose up -d --build
docker compose ps
curl http://localhost:8080/api/info
```

Documentation: [SUBMISSION_GUIDE_RU.md](SUBMISSION_GUIDE_RU.md).  
API tests: `./scripts/api_demo.sh`.
