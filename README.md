# Versions Dashboard POC

This repository contains an **exercise** demonstrating a complete Versions Dashboard workflow:



- **Jenkinsfile** that clones the code on a build server, builds a Docker image, uploads it to DockerHub, and then deploys the application as a Pod on a separate deploy server (Minikube).
- **GitHub Actions** (Sonar Cloud & Snyk) run automatically on every push to the `development` branch, ensuring code quality and security checks.

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Key Components](#key-components)
- [Workflow Stages](#workflow-stages)
- [Prerequisites](#prerequisites)
- [How It Works](#how-it-works)
- [Reference](#reference)
- [License](#license)

---

## Architecture Overview

![alt text](https://github.com/Andrey-B-lab/exercise-python-application/blob/development/architecture.png?raw=true)

---

## Key Components

1. **Jenkins Pipeline**  
   - **Build**: Clones GitHub repo, builds Docker image.  
   - **Push**: Uploads the new image to DockerHub (public repo).  
   - **Deploy**: Spins up a Pod in Minikube, exposes via port 443 using Nginx.

2. **Sonar Cloud & Snyk**  
   - Integrated into GitHub Actions.  
   - Automatically scans every push to the `development` branch for code quality and security vulnerabilities.

3. **Server Details**  
   - **server-1 (build-node-1)**: Ubuntu 24.04 with Docker installed (for building images).  
   - **server-2 (deploy-node-1)**: Ubuntu 24.04 with Minikube (for hosting the application).  
   - **Route 53**: Domain name pointed to the `deploy-node-1` instance to allow external traffic over HTTPS.

---

## Workflow Stages

1. **Code Commit & Test (GitHub Actions)**  
   - On push to `development`, Sonar Cloud checks for code quality; Snyk checks for vulnerabilities.

2. **Build (Jenkins)**  
   - Jenkins clones the GitHub repository on **build-node-1**.  
   - Docker image is built locally, tagged, and pushed to DockerHub.

3. **Deploy (Jenkins)**  
   - Jenkins connects to **deploy-node-1** (Minikube).  
   - Pod is created using the newly pushed Docker image.  
   - Nginx is configured to serve traffic on port **443**.

4. **Access (Public)**  
   - The application can be accessed via the domain configured in **Route 53**.  
   - Nginx handles SSL termination, so traffic is served securely.

---

## Prerequisites

- **Jenkins** installed (or containerized) with credentials for:
  - GitHub (to pull code).
  - DockerHub (to push images).
- **Docker** installed on the build server.
- **Minikube** installed on the deploy server.
- **Nginx** configured to expose traffic on port 443.
- **Route 53** domain properly pointed to the `deploy-node-1` instance.

---

## How It Works

1. **Fork or Clone** this repository into your own GitHub account.  
2. **Configure** Jenkins credentials for GitHub and DockerHub.  
3. **Set Up** `server-1` (Ubuntu with Docker) for building.  
4. **Set Up** `server-2` (Ubuntu with Minikube) for deployment.  
5. **Update** Jenkinsfile with your DockerHub repository name.  
6. **Run** the Jenkins pipeline:
   1. **Checkout** GitHub code.  
   2. **Build** Docker image.  
   3. **Push** image to DockerHub.  
   4. **Deploy** to Minikube.  
   5. **Verify** via a curl or browser test on `https://<YOUR_DOMAIN>`.  

---

## Reference

For a detailed, step-by-step explanation, check out this Medium article:  
[**DevOps Example Project for Your Resume**](https://medium.com/devops-technical-notes-and-manuals/devops-example-project-for-your-resume-db45a77d6607)

---

## License

This repository is provided as-is for educational purposes. Feel free to fork and modify it for your own learning or demonstrations.

**Happy DevOps-ing!**


