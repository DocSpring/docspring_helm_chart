# Helm Chart for DocSpring Enterprise

This repository contains a Helm chart for deploying DocSpring Enterprise in a Kubernetes cluster.

# Setup

### Clone the Helm Chart Repo

```
git clone https://github.com/DocSpring/docspring_helm_chart.git
cd docspring_helm_chart
```

### Copy `values.example.yaml` to `values.yaml`

```
cp values.example.yaml values.yaml
```

### Create Docker Hub Authentication Secret

```
kubectl create secret docker-registry dockerhub-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username="<your-username>" \
  --docker-password="<your-password>" \
  --docker-email="<your-email>"
```

### Verify DockerHub credentials and Ensure Application Can Boot

```
./run_command.sh ./bin/smoke_test
```

### Generate Secrets

```
# Generate secret for SECRET_KEY_BASE
openssl rand -hex 64

# Generate secret for SUBMISSION_DATA_ENCRYPTION_KEY
openssl rand -hex 32
```

Set these environment variables in the `sharedEnv` section in `values.yaml`.

### Configure Other Environment Variables

Update the other environment variables for `sharedEnv`, and for the `web` and `worker` services in `values.yaml`.

* Set `DOMAIN_NAME` to the hostname where the application will be accessible.
* Set `DATABASE_URL` to your Postgres connection string
* Set `REDIS_URL` to your Redis connection string

You will also need to configure a file storage service such as AWS S3, Google Cloud Storage, or MinIO.

### Install the Helm Chart

```
helm install docspring-enterprise . --values values.yaml
```

### Check Pod Status

```
kubectl get pods -A
```

### Set Up Database

```
./run_command.sh rake db:prepare
```

### Set up SSL

We have not included configuration for `cert-manager` in this Helm chart.
You can use `cert-manager` to set up SSL for your domain.

# Upgrade

```
helm upgrade docspring-enterprise . --values values.yaml
```

# Uninstall

```
helm uninstall docspring-enterprise
```

# Development

* Check Helm chart for errors: `helm lint`
* Inspect generated manifests: `helm template . --values values.yaml`
* Validate with Kubernetes dry run: `helm template . --values values.yaml | kubectl apply --dry-run=client -f -`
* Use `--force` flag to update helm chart while testing: `helm upgrade --force docspring-enterprise . --values values.yaml`

### Access the web service locally

Add this entry to `/etc/hosts`:

```
127.0.0.1     docspring-enterprise.localhost
```

Update `values.yaml`:

* Comment out `FORCE_SSL: "true"` (we have not configured SSL locally.)
* Set `PUBLIC_PORT` to `4001`

Then upgrade the Helm chart.

Use `kubectl port-forward` to access the service locally:

```
kubectl port-forward svc/docspring-enterprise 4001:4001
```

Check that everything is working:

```
curl http://docspring-enterprise.localhost:4001/health
```

Then visit `http://docspring-enterprise.localhost:4001` in your browser.
