locals {
  ecr_repo_name = "vercel-ai-chatbot"
}

resource "aws_ecr_repository" "app" {
  name = local.ecr_repo_name
}

data "aws_iam_policy_document" "apprunner_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["build.apprunner.amazonaws.com", "tasks.apprunner.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "apprunner_instance_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [
        "tasks.apprunner.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "apprunner_instance" {
  name               = "vercel-ai-chatbot-apprunner-instance-role"
  assume_role_policy = data.aws_iam_policy_document.apprunner_instance_assume.json
}

data "aws_iam_policy_document" "apprunner_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "secretsmanager:GetSecretValue"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "apprunner_instance_policy" {
  name   = "vercel-ai-chatbot-apprunner-instance-policy"
  policy = data.aws_iam_policy_document.apprunner_policy.json
}

resource "aws_iam_policy" "apprunner_policy" {
  name   = "vercel-ai-chatbot-apprunner-policy"
  policy = data.aws_iam_policy_document.apprunner_policy.json
}

resource "aws_iam_role_policy_attachment" "apprunner_attach" {
  role       = aws_iam_role.apprunner_instance.name
  policy_arn = aws_iam_policy.apprunner_policy.arn
}

resource "aws_iam_role_policy_attachment" "apprunner_instance_attach" {
  role       = aws_iam_role.apprunner_instance.name
  policy_arn = aws_iam_policy.apprunner_instance_policy.arn
}

locals {
  runtime_env_secrets = {
    NEXT_PUBLIC_SUPABASE_URL      = aws_ssm_parameter.next_public_supabase_url.arn
    NEXT_PUBLIC_SUPABASE_ANON_KEY = aws_ssm_parameter.next_public_supabase_anon_key.arn
    NEXTAUTH_SECRET               = aws_ssm_parameter.nextauth_secret.arn
    SUPABASE_SERVICE_ROLE_KEY     = aws_secretsmanager_secret.supabase_service_role_key.arn
    OPENAI_API_KEY                = aws_secretsmanager_secret.openai_api_key.arn
  }
}

resource "aws_apprunner_service" "app" {
  service_name = "vercel-ai-chatbot-dev"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access.arn
    }
    image_repository {
      image_identifier      = "${aws_ecr_repository.app.repository_url}:latest"
      image_repository_type = "ECR"

      image_configuration {
        port = "3000"

        runtime_environment_secrets = local.runtime_env_secrets
      }
    }

    auto_deployments_enabled = true
  }
depends_on = [
  aws_ecr_repository.app
]
  instance_configuration {
    cpu    = "1024"
    memory = "2048"
    instance_role_arn = aws_iam_role.apprunner_instance.arn
  }
 tags = {
    App = "vercel-ai-chatbot"
    Env = "dev"
  }
}

