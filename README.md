# FitCore – Local Infrastructure

This repository contains the development environment for the FitCore project.

## Included services

- PostgreSQL (port 5432)
- RabbitMQ + UI (ports 5672, 15672)
- MinIO (ports 9000, 9001)

## How to use

```bash
# Clone all repositories
chmod +x ./scripts/setup.sh

./scripts/setup.sh

# Start services
docker-compose up -d

# Stop services
docker-compose down