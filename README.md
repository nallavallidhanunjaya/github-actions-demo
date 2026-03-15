# 🚀 GitHub Actions CI/CD Pipeline with AWS ECR and ECS

## 📌 Project Overview
This project demonstrates a **complete CI/CD pipeline using GitHub Actions** to automatically build, push, and deploy a containerized Python web application to AWS.

Whenever code is pushed to the repository, the pipeline performs the following tasks:

1. Builds a Docker image for the application  
2. Pushes the Docker image to **Amazon Elastic Container Registry (ECR)**  
3. Deploys the latest container image to **Amazon Elastic Container Service (ECS)**  

The deployed application displays a **simple DevOps dashboard** showing container information and deployment time.

---

# 🏗 Architecture

```
Developer Push Code
        │
        ▼
GitHub Repository
        │
        ▼
GitHub Actions CI Pipeline
        │
        ├── Install Dependencies
        ├── Run Code Checks
        ├── Build Docker Image
        ├── Push Image to Amazon ECR
        └── Deploy Updated Container to ECS
                │
                ▼
        Amazon ECS Service
                │
                ▼
      Running Containerized Application
```

---

# ⚙️ Technologies Used

- Python (Flask)
- Docker
- GitHub Actions
- AWS ECR (Container Registry)
- AWS ECS Fargate (Container Hosting)
- AWS IAM (Access Management)

---

# 📂 Project Structure

```
github-actions-demo
│
├── app.py
├── requirements.txt
├── Dockerfile
├── .dockerignore
│
├── templates
│   └── index.html
│
└── .github
     └── workflows
          └── ci.yml
```

---

# 🌐 Application

The application is a **Flask-based web dashboard** displaying:

- Application name
- Container hostname
- Deployment timestamp

Example output:

```
🚀 DevOps CI/CD Deployment

Application: GitHub Actions Demo
Container Hostname: ecs-task-xxxx
Deployment Time: 2026-03-15 20:30:12
```

---

# 🐳 Docker Setup

Dockerfile used to build the container image:

```dockerfile
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python","app.py"]
```

---

# 🔐 AWS IAM Setup

An IAM user was created for GitHub Actions with permissions required to push images to ECR.

Required permissions include:

- `ecr:GetAuthorizationToken`
- `ecr:BatchCheckLayerAvailability`
- `ecr:CompleteLayerUpload`
- `ecr:UploadLayerPart`
- `ecr:PutImage`

The IAM user's **Access Key** and **Secret Key** are stored securely in GitHub Secrets.

---

# 🔑 GitHub Secrets

The following secrets are configured in the repository:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
ECR_REPOSITORY
```

These credentials allow GitHub Actions to authenticate with AWS.

---

# 🔄 GitHub Actions Workflow

Workflow location:

```
.github/workflows/ci.yml
```

The workflow performs the following steps:

1. Checkout repository
2. Configure AWS credentials
3. Login to Amazon ECR
4. Build Docker image
5. Push image to ECR
6. Deploy container to ECS

Example workflow snippet:

```yaml
name: CI Pipeline with ECR

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2

      - name: Build Docker Image
        run: docker build -t github-actions-demo .

      - name: Tag Docker Image
        run: docker tag github-actions-demo:latest ${{ steps.login-ecr.outputs.registry }}/${{ secrets.ECR_REPOSITORY }}:latest

      - name: Push Docker Image
        run: docker push ${{ steps.login-ecr.outputs.registry }}/${{ secrets.ECR_REPOSITORY }}:latest

      - name: Deploy to ECS
        run: |
          aws ecs update-service \
            --cluster github-actions-cluster \
            --service github-actions-service \
            --force-new-deployment
```

---

# 🚀 Deployment Process

Every push to the **main branch** automatically triggers the pipeline:

```
Push Code
   ↓
GitHub Actions Pipeline
   ↓
Build Docker Image
   ↓
Push Image to ECR
   ↓
Update ECS Service
   ↓
Deploy Latest Container
```

The ECS service pulls the latest image from ECR and starts new containers.

---

# 🧪 How to Access the Application

After deployment:

1. Open **AWS ECS Console**
2. Navigate to the running task
3. Copy the **Public IP Address**
4. Open the browser:

```
http://PUBLIC-IP:5000
```

---

# 📚 Key Concepts Demonstrated

This project demonstrates:

- GitHub Actions CI/CD workflows
- Docker image build automation
- Secure AWS authentication using GitHub secrets
- Container registry management with ECR
- Automated deployments using ECS
- DevOps CI/CD best practices

---

# 💡 Future Improvements

Possible enhancements:

- Docker image versioning using Git commit SHA
- Multi-stage pipelines (build → deploy)
- Automated testing
- Monitoring and logging
- Use GitHub OIDC authentication instead of IAM access keys

---

# 👨‍💻 Author

Dhanunjaya Nallavalli  
DevOps Engineer

---

⭐ If you found this project useful, consider giving it a star!
