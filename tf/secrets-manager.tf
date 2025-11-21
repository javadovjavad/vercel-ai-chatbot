resource "aws_secretsmanager_secret" "supabase_service_role_key" {
  name = "vercel-ai-chatbot/dev/SUPABASE_SERVICE_ROLE_KEY"
}

resource "aws_secretsmanager_secret_version" "supabase_service_role_key" {
  secret_id     = aws_secretsmanager_secret.supabase_service_role_key.id
  secret_string = "dummy"
  lifecycle {
    ignore_changes = [ secret_string ]
  }
}

resource "aws_secretsmanager_secret" "openai_api_key" {
  name = "vercel-ai-chatbot/dev/OPENAI_API_KEY"
}

resource "aws_secretsmanager_secret_version" "openai_api_key" {
  secret_id     = aws_secretsmanager_secret.openai_api_key.id
  secret_string = "dummy"
  lifecycle {
    ignore_changes = [ secret_string ]
  }
}

# resource "aws_secretsmanager_secret" "github_pat" {
#   name = "vercel-ai-chatbot/dev/GITHUB_PAT"
# }

# resource "aws_secretsmanager_secret_version" "github_pat" {
#   secret_id     = aws_secretsmanager_secret.github_pat.id
#   secret_string = "dummy"
# }
