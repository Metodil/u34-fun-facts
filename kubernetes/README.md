## Files for Deploy app in kubernetes cluster
> - app-vars.yaml  - ConfigMap for set vars in environment
### Generator
> - generator-deployment.yaml  - Backend deployment for generating data
### Storage
> - storage-deployment.yaml  - Storage deployment for database
> - storage-svc.yaml  - Service for database
### Web
> - web-deployment.yaml  - Deployment for web interface
> - web-svc.yaml  - Service with LoadBalancer web interface
