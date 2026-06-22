# End to End GitOps with ArgoCD and AKS

This repository contains a sample application and the necessary configuration to demonstrate **GitOps** workflows using **Argo CD**. The goal is to enable Argo CD to automatically sync changes from this Git repository to a Kubernetes cluster, while also integrating SonarQube for code quality analysis.

## Repository Overview

- `deployment.yaml` – Kubernetes Deployment manifest that Argo CD will apply.
- `Dockerfile` – Docker image definition for the sample web application.
- `sonar-project.properties` – SonarQube configuration for static code analysis.
- `version.txt` – Simple version file used by the CI pipeline.
- `webapp/` – The sample web application (HTML/JS) that is containerised.
- `demo/` – Additional demo assets.

## How It Works

1. **Argo CD Application**
   - Argo CD watches this repository (or a specific path) and syncs the manifests in `deployment.yaml` to the target Kubernetes cluster.
   - When a change is pushed to the `main` branch, Argo CD detects the change and applies the updated resources.

2. **SonarQube Integration**
   - The `sonar-project.properties` file configures SonarQube analysis for the JavaScript code under `webapp/`.
   - CI pipelines (e.g., GitHub Actions, Azure Pipelines) can run `sonar-scanner` using this configuration and publish quality reports.

## Quick Start

1. **Build and Push Docker Image**
   - This step is **automatically handled** by the `buildandpushdockerimage.yml` GitHub Actions workflow when you commit and push changes to the repository.
   - The workflow builds the Docker image and pushes it to Docker Hub using the version from `version.txt`.
   - Trigger manually from the GitHub Actions tab if needed.

2. **Run Code and Container Scans** (Optional)
   - The `gitops.yml` workflow automatically runs SonarQube code analysis on every commit.
   - The `run_container_scan.yml` workflow scans the Docker image for vulnerabilities.
   - Both workflows can be triggered manually from the GitHub Actions tab.

3. **Deploy with Argo CD**
   - Create an Argo CD Application that points to this repository and the `deployment.yaml` path.
   - Sync the application; Argo CD will create the Deployment, Service, etc., using the Docker image pushed by the GitHub Actions workflow.

4. **Verify the Deployment**
   - Check the Kubernetes cluster to ensure the pods are running with the latest image version.
   - Argo CD will automatically sync any new commits to this repository.

---

## GitHub Actions

The repository includes three CI workflows located in the `.github/workflows` directory:

### 1. Build and Push Docker Image (`buildandpushdockerimage.yml`)
This workflow builds the Docker image for the Super Mario web app and pushes it to Docker Hub.
Key steps:
* Checkout the repository.
* Set up Docker Buildx.
* Log in to Docker Hub using `DOCKER_USERNAME` and `DOCKER_TOKEN` secrets.
* Build and push the image with a version tag derived from `version.txt`.

### 2. SonarQube Code Scan (`gitops.yml`)
Runs a SonarQube analysis on the JavaScript source code.
Key steps:
* Checkout the repository with full history (`fetch-depth: 0`).
* Execute the `sonarsource/sonarqube-scan-action` using `SONAR_HOST_URL` and `SONAR_TOKEN` secrets.
* (Optional) Quality gate check can be enabled by uncommenting the related step.

### 3. Container Scan (`run_container_scan.yml`)
Performs a vulnerability scan of the built Docker image using Trivy.
Key steps:
* Checkout the repository.
* Run Trivy via `aquasecurity/trivy-action` against the image `docker.io/nehas1908/supermariogitopsproject:v2`.
* Upload the SARIF results to GitHub Security tab using `github/codeql-action/upload-sarif`.

These workflows can be triggered manually via the **workflow_dispatch** event or automatically on pushes/PRs when the commented sections are enabled.

## Contributing

Feel free to open issues or submit pull requests to improve the demo, add more Kubernetes resources, or enhance the SonarQube configuration.

---

*This project is intended for educational purposes to illustrate GitOps principles with Argo CD and SonarQube.*