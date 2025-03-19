# Homelab

Welcome to my homelab repository. This repository contains the configuration and setup for my personal homelab environment.

## Summary

My homelab is currently running:
- **Ubuntu Server 24.04** Linux operating system.
- **K3s**: A lightweight Kubernetes distribution for running Kubernetes clusters.
- **Terraform**: Infrastructure as Code (IaC) tool used to provision and manage the infrastructure.

## What's Running?

### Network
- **Pi-hole**: A network-wide ad blocker.

### Monitoring

- **Prometheus**: Monitoring and alerting toolkit.
- **Grafana**: Analytics and monitoring platform.
- **Loki**: Log aggregation system.

### Apps
- **Plex**: A classic self hosted media server.
- **utorrent**: A torrenting server.


## Deployments

Deployments are run by the `deploy.sh` script. A `.env` file is required specifying the `USER` and `HOST`. The user must also be set up to SSH to the homelab without requiring a password.


