output "apprunner_service_arn" {
  description = "ARN of the App Runner service (used by CodeBuild to trigger deployments)"
  value       = aws_apprunner_service.app.arn
}

output "apprunner_service_url" {
  description = "Public URL of the App Runner service"
  value       = aws_apprunner_service.app.service_url
}

output "ecr_repository_url" {
  description = "ECR repository URL for the app image"
  value       = aws_ecr_repository.app.repository_url
}

output "codepipeline_name" {
  description = "Name of the CodePipeline for this app"
  value       = aws_codepipeline.pipeline.name
}

output "codebuild_project_name" {
  description = "Name of the CodeBuild project used by the pipeline"
  value       = aws_codebuild_project.build.name
}

output "ssm_next_public_supabase_url_name" {
  description = "SSM parameter name for NEXT_PUBLIC_SUPABASE_URL"
  value       = aws_ssm_parameter.next_public_supabase_url.name
}

output "ssm_next_public_supabase_anon_key_name" {
  description = "SSM parameter name for NEXT_PUBLIC_SUPABASE_ANON_KEY"
  value       = aws_ssm_parameter.next_public_supabase_anon_key.name
}

output "ssm_nextauth_secret_name" {
  description = "SSM parameter name for NEXTAUTH_SECRET"
  value       = aws_ssm_parameter.nextauth_secret.name
}

output "secret_openai_api_key_arn" {
  description = "Secrets Manager ARN for OPENAI_API_KEY"
  value       = aws_secretsmanager_secret.openai_api_key.arn
}
