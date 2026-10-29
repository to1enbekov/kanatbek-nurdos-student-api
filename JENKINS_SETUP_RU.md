# Jenkins — настройка и демонстрация CI/CD

## 1. Jenkins и Docker

Для задания нужен Jenkins с Java 21, Gradle wrapper (в репозитории)
и правом выполнять Docker CLI на выделенном trusted agent.
Jenkins уже установлен? Можно оставить существующий, если команда
`docker version` работает из executor и `java -version` показывает 21.

Опциональная установка отдельного Jenkins-контейнера для ЛОКАЛЬНОЙ
лабораторной (привязка Docker socket даёт Jenkins широкие права на хост;
не использовать это в публичной/недоверенной среде):

```bash
docker build -f infra/jenkins/Dockerfile -t kanatbek-nurdos-midterm-jenkins:local .
docker volume create kanatbek-nurdos-midterm-jenkins-home
docker run -d --name kanatbek-nurdos-midterm-jenkins \
  -p 127.0.0.1:8081:8080 \
  -v kanatbek-nurdos-midterm-jenkins-home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --group-add "$(stat -c %g /var/run/docker.sock)" \
  kanatbek-nurdos-midterm-jenkins:local
docker exec kanatbek-nurdos-midterm-jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Открой `http://localhost:8081`. Настрой пользователя и установи
стандартные плагины, включая Pipeline, Git, Credentials.
Если порт 8081 занят — поменяй порт хоста.

## 2. Создать Pipeline job

New Item -> `Kanatbek_Nurdos_Student_API` -> Pipeline.
Pipeline definition: `Pipeline script from SCM`.
SCM: Git -> Repository URL: `https://github.com/YOUR_USERNAME/kanatbek-nurdos-student-api.git`.
Branch specifier: `*/main`. Script Path: `Jenkinsfile`.
GitHub публичный: обычно credentials не нужны. Приватный: Jenkins Credentials,
а не пароль в Jenkinsfile. На Jenkins agent должны работать `git`, `curl`,
`java`, `docker`, и быть доступ в интернет до Gradle/Maven.
Нажми Build Now, проверь 5 стадий и `Console Output`.
Jenkinsfile настроен на polling Git каждые ~2 минуты (`H/2 * * * *`),
фактическое время запуска зависит от Jenkins и доступности GitHub.

## 3. Controlled FAILED -> FIXED SUCCESS (только отдельная ветка)

Из проекта на WSL:

```bash
./scripts/ci_failure_demo.sh prepare
git push -u origin feature/kanatbek-nurdos-ci-failure
```

Создай отдельный Jenkins Pipeline job `Kanatbek_Nurdos_CI_Failure_Demo`
с тем же GitHub репозиторием, но branch specifier
`*/feature/kanatbek-nurdos-ci-failure`. Запусти Build Now — намеренно
не проходит тест `TemporaryFailureDemoTest`; статус FAILED.
Сохрани снимок ошибки и Console Output. Затем:

```bash
./scripts/ci_failure_demo.sh fix
git push origin feature/kanatbek-nurdos-ci-failure
```

Запусти job или дождись polling. Тест пройдёт; сохрани SUCCESS.
ДЕМО-ветку в main не сливать. Вернись в `main`: `git switch main`.

## 4. Проверить polling / автоматический запуск

В Jenkins main job включён `pollSCM('H/2 * * * *')`.
В `main` выполни:

```bash
git switch main
echo "CI polling demonstration $(date -Is)" >> docs/polling-demo.txt
git add docs/polling-demo.txt
git commit -m "ci(Kanatbek Nurdos): trigger automatic Jenkins build"
git push origin main
```

Jenkins после следующей проверки SCM должен автоматически запустить pipeline.
Сохрани Build History и Console Output. Если не запускается — проверь,
что Jenkins job подключён к main и включён, `git ls-remote` работает
из executor, а Jenkinsfile содержит polling trigger.

## 5. На защите объяснить

CI = интеграция кода с автоматическими сборкой и тестированием.
Continuous Delivery = приложение подготовлено к развёртыванию, запуск
может требовать ручного подтверждения. Continuous Deployment = прошедшее
проверки изменение автоматически идёт в production. Для этого задания
автоматический deployment не обязателен.

## Проверенная локальная установка

Учебный Jenkins Midterm доступен только на http://localhost:8081, с отдельным home volume и обязательной авторизацией. Docker socket доступен только доверенной учебной установке. Java 21, Docker CLI/Buildx, Git и Pipeline plugins включены в образ. Старый Week 6 Jenkins и его jobs не менялись. Основная job читает публичный GitHub main; секреты SCM не нужны.
