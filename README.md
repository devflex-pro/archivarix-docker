# Archivarix CMS Docker Image

![Build and Publish](https://github.com/devflex-pro/archivarix-cms/actions/workflows/docker-image.yml/badge.svg)

## Description

This repository contains a Docker image for Archivarix CMS, designed for deployment using `php:fpm` and Nginx. It also includes GitHub Actions to automate the building and publishing of Docker images to Docker Hub on every push to the main branch or when a new tag is created.

## Project Structure

```
project/
├── archivarix/                # Directory containing Archivarix CMS files
├── .github/
│   └── workflows/
│       └── docker-image.yml   # CI/CD configuration file
├── nginx.conf                 # Nginx configuration file
├── Dockerfile                 # Dockerfile for building the image based on php-fpm
├── docker-compose.yml         # File for launching containers with Docker Compose
└── README.md                  # Project description file
```

## Usage

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/your-repository-name.git
cd your-repository-name
```

### 2. Run the Project Locally

Use `docker-compose` to run the application locally:

```bash
docker-compose up -d
```

Once the containers are up and running, the application will be accessible at `http://localhost:8080`.

### 3. Build and Run the Docker Container Manually

If you want to build and run the Docker container manually:

```bash
docker build -t your-dockerhub-username/archivarix-cms:latest .
docker run -p 8080:80 your-dockerhub-username/archivarix-cms:latest
```

### 4. CI/CD Setup

This project is configured for automatic Docker image building and publishing using GitHub Actions. On every push to the main branch or when a new tag (e.g., `v1.0.0`) is created, GitHub Actions will:

1. Check out the repository code.
2. Build the Docker image.
3. Publish it to Docker Hub with the `latest` tag and, if a tag is present, with the corresponding version tag.

## GitHub Actions Configuration

To enable GitHub Actions, you need to add the following secrets to your repository:

- `DOCKER_USERNAME`: Your Docker Hub username.
- `DOCKER_PASSWORD`: Your Docker Hub password or access token.

Secrets can be added through: `Settings` → `Secrets and variables` → `Actions`.

## Environment Variables

You can modify the following environment variables in the `docker-image.yml` if needed:

- `IMAGE_NAME`: The name of the Docker image (default: `your-dockerhub-username/archivarix-cms`).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

