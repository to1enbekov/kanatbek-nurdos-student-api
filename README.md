# Kanatbek Nurdos — Student API (DevOps Midterm)

**Student:** Kanatbek Nurdos  
**Course:** DevOps Midterm  
**Project:** Spring Boot CRUD API + PostgreSQL + Docker + Jenkins

**CRUD feature - Kanatbek Nurdos.** This feature implements student create,
list, lookup, update and delete through StudentController and StudentService.
In particular, PUT updates fullName, email and course for an existing ID;
a missing student returns HTTP 404, and invalid input returns HTTP 400.
StudentServiceTest and StudentControllerTest cover the CRUD service and
controller responses. This README note was added during the final requirements
audit to complete the feature-branch documentation required by Task 2.2.


Project status: Student CRUD feature implemented and tested by Kanatbek Nurdos.

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
