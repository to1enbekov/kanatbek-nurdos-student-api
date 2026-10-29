# Kanatbek Nurdos — Student API (DevOps Midterm)

**Student:** Kanatbek Nurdos  
**Course:** DevOps Midterm  
**Project:** Spring Boot CRUD API + PostgreSQL + Docker + Jenkins

Project status: CRUD API implemented; documentation branch merged after manual conflict resolution.

## How to run (Ubuntu / WSL)

Prerequisites: Ubuntu/WSL, Docker Engine or Docker Desktop integrated with WSL,
Docker Compose v2, `curl`, `python3`, and network access to Gradle/Maven Central.
Java 21 is required for local Gradle tests and Jenkins builds. Docker-only
build uses Java 21 inside official JDK/JRE images.

```bash
cp .env.example .env
nano .env                         # change the POSTGRES_PASSWORD value
chmod +x gradlew scripts/*.sh
./scripts/setup_gradle_wrapper.sh # verify the committed official Gradle wrapper JAR
./gradlew --no-daemon test
docker compose up -d --build
docker compose ps
curl http://localhost:8080/api/info
./scripts/api_demo.sh
./scripts/collect_evidence.sh
./scripts/docker_evidence.sh
./scripts/persistence_demo.sh
```

**Never run `docker compose down -v` during the persistence demo**: it removes the database volume.
Stop cleanly with `docker compose down` (without `-v`).

## API endpoints

| Method | Path | Description | Expected status |
|---|---|---|---|
| GET | `/api/info` | Student and project identity | 200 |
| POST | `/api/students` | Create student | 201 |
| GET | `/api/students` | List all students | 200 |
| GET | `/api/students/{id}` | Get one by ID | 200 or 404 |
| PUT | `/api/students/{id}` | Edit student | 200 or 404 |
| DELETE | `/api/students/{id}` | Delete student | 204 or 404 |
| GET | `/actuator/health` | Application health | 200 when healthy |

Example student (test identity; not a real contact email):

```json
{"fullName":"Kanatbek Nurdos","email":"nurdos@example.com","course":"DevOps"}
```

## Project parts

- **Part 1 Linux:** `scripts/Kanatbek_Nurdos_system_report.sh` and `scripts/project_structure_demo.sh`, `scripts/collect_evidence.sh`.
  Permissions `744` mean owner `rwx`, group `r--`, others `r--`.
- **Part 2 Git:** `main`, two personal feature branches, multiple actual commits,
  a genuinely resolved README merge conflict, annotated tag.
- **Part 3 Docker:** multi-stage Dockerfile, Compose with PostgreSQL, named volume,
  health check and isolated network; CRUD demo + persistence demo scripts.
- **Part 4 Jenkins:** declarative pipeline with Checkout, Build, Test, Docker Build, Verify,
  scheduled SCM polling. `infra/jenkins/Dockerfile` helps create a Docker-capable agent.

## Other documentation

- `SUBMISSION_GUIDE_RU.md` — what the original task demands, exact evidence, steps to submit.
- `DEFENSE_RU.md` — Russian defense text and likely questions.
- `JENKINS_SETUP_RU.md` — Jenkins configuration and fail/fix demo.
- `docs/REAL_MERGE_CONFLICT.txt` — output of a genuine local Git merge conflict.

## Git author note

New commits use `159691545+to1enbekov@users.noreply.github.com`, associated with
the verified GitHub account `to1enbekov`. Original prepared commits retain their
placeholder author address. Their history was preserved without rewriting.

## Security

Database passwords live only in untracked `.env` and Compose environment variables.
Never upload `.env`, real credentials, passwords or tokens to GitHub. The demo API
has no authentication, so bind it to localhost and do not expose it publicly.

## Verified wrapper and local Jenkins

The standard Gradle 8.14 wrapper is committed. Its JAR SHA-256 and distribution checksum are verified against https://gradle.org/release-checksums/. The original custom download URL returned 404 and was replaced. New commits use the GitHub no-reply address for to1enbekov; original history is preserved.

For an isolated local Jenkins use image `kanatbek-nurdos-midterm-jenkins:local`, container `kanatbek-nurdos-midterm-jenkins`, port `127.0.0.1:8081`, and a new dedicated home volume. The image includes Java 21, Git, Docker CLI/Buildx and Pipeline plugins. It does not replace the older Week 6 Jenkins.
