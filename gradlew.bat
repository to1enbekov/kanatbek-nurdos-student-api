@echo off
setlocal
set "APP_HOME=%~dp0"
if not exist "%APP_HOME%gradle\wrapper\gradle-wrapper.jar" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $base='https://services.gradle.org/distributions/'; $dest='%APP_HOME%gradle\wrapper\gradle-wrapper.jar'; Invoke-WebRequest ($base+'gradle-8.14-wrapper.jar') -OutFile $dest; $expected=(Invoke-WebRequest ($base+'gradle-8.14-wrapper.jar.sha256')).Content.Trim().Split(' ')[0]; $actual=(Get-FileHash $dest -Algorithm SHA256).Hash.ToLower(); if($actual -ne $expected){Remove-Item $dest; throw 'Gradle wrapper checksum mismatch'}"
  if errorlevel 1 exit /b 1
)
if defined JAVA_HOME (
  set "JAVA_EXE=%JAVA_HOME%\bin\java.exe"
) else (
  set "JAVA_EXE=java"
)
"%JAVA_EXE%" -Dorg.gradle.appname=gradlew -classpath "%APP_HOME%gradle\wrapper\gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain %*
exit /b %ERRORLEVEL%
