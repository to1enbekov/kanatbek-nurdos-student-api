# DevOps Midterm — что сделать и что сдавать

Студент: **Kanatbek Nurdos**. Название проекта: `kanatbek-nurdos-student-api`.

## Что прямо указано в документе преподавателя

**Часть 1 (Linux administration):** структура папок, личный Bash-скрипт,
лог (имя содержит фамилию и имя), сведения о системе/CPU/RAM/диске,
права 744, backup README, вывод `ls -l`, просмотр процессов/Java,
`tail -n 5`, `grep`, анализ в отдельный файл, объяснить `>` и `>>`.
Evidence: демонстрация терминала, исходник скрипта, лог, права и backup.

**Часть 2 (Git/GitHub):** инициализация, Git user.name/user.email,
`.gitignore`, первый именной commit; личная CRUD-ветка с минимум двумя
содержательными коммитами; merge в main; отдельная ветка документации;
настоящий README конфликт и ручное разрешение; GitHub remote + push веток;
персональный tag; показать историю и объяснить секреты в Git.
Evidence: ссылка GitHub, ветки, коммиты, merge, конфликт и tag.

**Часть 3 (Docker/Docker Compose):** multi-stage JDK → JRE image; Gradle/JAR;
image с персональной меткой, Compose для API + PostgreSQL; переменные
окружения, named volume, сеть, pg_isready healthcheck; show ps/logs/inspect,
exec в контейнере, stop/restart, rebuild после изменения версии, сохранение
записей PostgreSQL после перезапуска; CRUD: POST/GET-all/GET-ID/PUT/DELETE/404.
Evidence: рабочие контейнеры, корректные ответы API и persistence.

**Часть 4 (Jenkins):** job `Kanatbek_Nurdos_Student_API`, подключённый
к своему GitHub; JDK, Gradle wrapper, Docker-capable agent, credentials при
необходимости; 5 стадий Jenkinsfile; успешный pipeline; управляемая ошибка
на отдельной тестовой ветке, FAILED, исправление, SUCCESS; webhook либо
polling; новый commit запускает job автоматически; build history/log.
Deployment НЕ обязателен, если преподаватель не потребует отдельно.

**Формат сдачи в исходном файле НЕ задан:** нет указания Moodle/Canvas,
количества скриншотов, структуры итогового ZIP или срока сдачи.
Поэтому ниже рекомендуемый набор доказательств, а не дословное требование.

## Что уже лежит в ZIP

Исходный Spring Boot CRUD, тесты, Bash, Dockerfile, Compose,
Jenkinsfile, локальная Git-история с настоящим merge conflict + tag,
инструкции. ZIP включает `.git` для сохранения веток/истории.
Скриншоты реальных запусков, GitHub remote и Jenkins job не могут быть
получены без запуска на твоём компьютере и в Jenkins.

## Что сделать на своём ПК (WSL Ubuntu) — по порядку

1. Распакуй ZIP в Linux-каталог (например `~/devops/`).
   Команда: `cd ~/devops/kanatbek-nurdos-student-api`.
2. Проверь `git log --oneline --all --graph --decorate` и `git branch -a`.
   ZIP содержит реальную `.git`, не делай `git init` повторно.
3. `chmod +x gradlew scripts/*.sh`; затем `./scripts/project_structure_demo.sh`
       для подтверждения создания папок командами терминала.
4. `sudo apt update && sudo apt install -y curl git python3` (по необходимости).
5. Если нет Java 21 — `sudo apt install -y openjdk-21-jdk`.
       Запусти `java -version`, затем `./gradlew test` (доступ к Gradle/Maven нужен).
       Стандартные gradlew/gradlew.bat и официальный wrapper JAR уже находятся
       в Git. `./scripts/setup_gradle_wrapper.sh` проверяет JAR по официальному
       SHA-256. distributionSha256Sum проверяет скачиваемый Gradle ZIP.
       Исходный URL загрузки wrapper JAR возвращал 404 и заменён стандартным wrapper.

6. `cp .env.example .env` и замени пароль в `.env`.
7. `docker compose up -d --build`, затем `docker compose ps`.
8. `curl http://localhost:8080/api/info`, `./scripts/api_demo.sh`.
9. `./scripts/persistence_demo.sh` (доказывает хранение данных после stop/start).
10. `./scripts/collect_evidence.sh` и `./scripts/docker_evidence.sh`.
11. Для требования «пересобрать образ после изменения версии» выполни
        `./scripts/rebuild_version_demo.sh prepare`, затем
        `./scripts/rebuild_version_demo.sh build`, затем `git switch main`.
        Будет создан `evidence/part3-rebuild-version.txt`.
    12. `./scripts/check_submission.sh` — посмотреть, какие доказательства отсутствуют.
13. На GitHub создать пустой репозиторий `kanatbek-nurdos-student-api`
    (без автоматического README); затем вставить свой URL в команды:

```bash
git config user.name "Kanatbek Nurdos"
git config user.email "YOUR_REAL_GITHUB_EMAIL"
git remote add origin https://github.com/YOUR_USERNAME/kanatbek-nurdos-student-api.git
git push -u origin main
git push origin feature/kanatbek-nurdos-crud feature/kanatbek-nurdos-documentation
git push origin v1.0-kanatbek-nurdos
git remote -v
git log --all --oneline --graph --decorate
```

14. Следуй `JENKINS_SETUP_RU.md`: создать job, запустить pipeline,
    сохранить SUCCESS, затем FAILED → FIXED → SUCCESS на личной test-ветке.
15. Сделай дополнительный commit на main, push и покажи автоматический
    старт Jenkins через pollSCM.
16. Для защиты открой файлы evidence/*.txt и веб-интерфейс Jenkins/GitHub.

## Что приложить / показать преподавателю (рекомендация)

- Ссылка на свой GitHub репозиторий (обязательно по требованиям части 2).
- Исходники проекта (репозиторий или ZIP по правилам преподавателя).
- `evidence/part1-linux.txt`, лог и backup из папок `logs/`, `backups/`.
- `evidence/part2-git.txt`, GitHub branches/commits/tag и conflict.
- `evidence/part3-crud-api.txt`, `part3-docker.txt`, `part3-persistence.txt`.
- Скриншоты Jenkins SUCCESS, FAILED, FIXED SUCCESS, автозапуска и
  Console Output с `Kanatbek Nurdos`.

Внимание: `logs/`, `backups/`, `evidence/` исключены из Git намеренно;
их содержимое можно приложить отдельно, не добавляя в публичный репозиторий.
**Не используй синтетические логи вместо живых результатов.**
