# 📦 Reproducible AWS Deployment Pipeline  
### DevOps Engineer Challenge

This repository provides a reusable, production-ready AWS deployment pipeline for modern web applications.  
It follows TacticalEdgeAI’s requirements: **simple**, **reusable**, **maintainable**, fully **Infrastructure-as-Code**, and easily adaptable for the next 10+ projects.

---

# 🔧 Architecture Overview

### **Components**
| Component | Purpose |
|----------|----------|
| **AWS CodePipeline** | CI/CD orchestration triggered on `deploy_dev` branch |
| **AWS CodeBuild** | Builds Docker image & deploys to AWS |
| **AWS App Runner** | Fully managed hosting for containerized apps |
| **AWS Secrets Manager / SSM** | Secure storage for Supabase & app secrets |
| **AWS ECR** | Stores container images |
| **GitHub CodeConnection (OIDC)** | Secure GitHub → AWS integration |
| **Supabase (hosted)** | DB + Auth backend |

---

# 🏗️ High-Level Flow

```
GitHub (deploy_dev)
        │
        ▼
AWS CodePipeline ───► Source Stage
        │
        ▼
   AWS CodeBuild
        │   • Docker build
        │   • Pull secrets from AWS
        ▼
Deploy to AWS App Runner
        │
        ▼
GitHub Auto-Tag (deployed)
```

---

# 📁 Project Structure

```
/
├── Dockerfile
├── buildspec.yml
└── tf/
    ├── main.tf
    ├── provider.tf
    ├── iam.tf
    ├── pipeline.tf
    ├── secrets-manager.tf
    ├── ssm.tf
    ├── outputs.tf
    ├── variables.tf
```

---

# 🔐 Secrets Management (AWS SSM + Secrets Manager)

All application secrets (including Supabase environment variables) are stored securely in AWS.

### Example secrets:
```
/vercel-ai-chatbot/NEXT_PUBLIC_SUPABASE_URL  
/vercel-ai-chatbot/NEXT_PUBLIC_SUPABASE_ANON_KEY
```

Secrets are retrieved in CodeBuild at build/deploy time — **never stored in code or in git history.**

---

# 🔐 IAM Inline Policy — GitHub CodeConnection Permission

To allow CodePipeline to access the GitHub source, the following inline policy must be attached to:

### **IAM Role:** `vercel-ai-chatbot-codepipeline-role`

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowGitHubConnectionUse",
      "Effect": "Allow",
      "Action": [
        "codeconnections:UseConnection"
      ],
      "Resource": "<YOUR ARN HERE>"
    }
  ]
}
```

This prevents the common CodePipeline error:

```
The provided role does not have sufficient permissions.
```

---

# 🏗️ CI/CD Pipeline (CodePipeline + CodeBuild)

### Trigger
Pipeline automatically runs when code is pushed to:

```
deploy_dev
```

### Build Steps (`buildspec.yml`)
- Login to ECR  
- Build Docker image  
- Pull secrets from AWS  
- Push image to ECR  
- Trigger App Runner deployment  

### GitHub Auto-Tag
After successful deployment:

```
git tag deployed
git push origin deployed --force
```

This satisfies the challenge requirement for commit tagging.

---

# 🚀 Deployment Target — AWS App Runner

Reasons for choosing App Runner:

- Zero infrastructure management  
- Built-in HTTPS  
- Automatic deployment from ECR  
- Perfect for Supabase-based web apps  
- Very easy to reuse across multiple projects  

---

# 🧪 Deployment Guide (Step-by-Step)

## 1️⃣ Clone the repository
```bash
git clone https://github.com/<your-repo>
cd <repo>
```

## 2️⃣ Configure Terraform variables
Edit `variables.tf` or set via CLI:

```
ecr_repo_name               = "vercel-ai-chatbot"
app_runner_service_name     = "vercel-ai-chatbot-dev"
github_owner                = "YOUR GITHUB USERNAME"
github_repo                 = "vercel-ai-chatbot"
```

## 3️⃣ Apply Terraform
```bash
cd tf
terraform init
terraform apply
```

Terraform creates:
- ECR repository  
- App Runner service  
- IAM roles  
- SSM Parameter Store + Secrets Manager parameters  
- CodeBuild & CodePipeline  
- GitHub Connection  

## 4️⃣ Push to deploy_dev
```bash
git checkout deploy_dev
git push origin deploy_dev
```

## 5️⃣ Observe pipeline execution  
In AWS Console → CodePipeline  
- Source  
- Build  
- Deploy  
- Auto-tag  

## 6️⃣ Access the deployed application  
App Runner endpoint is shown in Terraform outputs.

---

# 🔁 Reusability — How to Adapt for a New App

To reuse this pipeline for *any* new project, simply update:

1. **ECR repo name**  
2. **App Runner service name**  
3. **Secrets list**  
4. **GitHub repo name**

Everything else (IAM, pipeline, CodeBuild, tagging) remains identical.  
This is the primary goal of the challenge.


---

# ✔️ Challenge Requirement Checklist

### Core Requirements
| Requirement | Status |
|------------|--------|
| CodePipeline + CodeBuild | ✅ |
| Reusable pattern | ✅ |
| Supabase integration | ✅ |
| AWS Secrets | ✅ |
| Auto-tagging | ✅ |
| Working deployment | ✅ |

### Infrastructure Quality
| Requirement | Status |
|------------|--------|
| Reproducible | 100% |
| IaC (Terraform) | ✅ |
| Documentation | ✔️ This README |

---

# ✔️ Final Result
This repository delivers a clean, reusable, AWS-native CI/CD pipeline using CodePipeline + CodeBuild + App Runner, following all TacticalEdgeAI challenge requirements.

It serves as a **template for 10+ future projects** with minimal adjustment.