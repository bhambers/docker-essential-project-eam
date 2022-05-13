# docker-essential-project-eam

An Unofficial Docker image for https://enterprise-architecture.org

This dockerfile will build and run The Essential Project EAM Protégé Server and Essential Viewer tools. AutoSave for the server is enabled so updates to the model will survive restarting the container, however for best results you should use a persistent data volume when starting the container as below.

Essential Model is 6.15

```shell
docker build -t essential/eam .
docker run -d -p 8080:8080 -p 5200:5200 -p 5100:5100 v- essential_data:/opt/essentialAM --name essentialEAM essential/eam
```

**Essential Viewer**

http://localhost:8080/essential_viewer (no login needed)

**Essential Import Utility**

http://localhost:8080/essential_import_utility

Username: admin@admin.com

Password: admin


**Protege Client**

/Protege_3.5/run_protege.sh

Open Other... -> Server

Host Maschine Name: locahost:5100

Username: Admin

Password : 12345