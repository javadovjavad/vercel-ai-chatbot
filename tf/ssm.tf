resource "aws_ssm_parameter" "next_public_supabase_url" {
  name  = "/vercel-ai-chatbot/dev/NEXT_PUBLIC_SUPABASE_URL"
  type  = "SecureString" 
  value = "dummy"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "next_public_supabase_anon_key" {
  name  = "/vercel-ai-chatbot/dev/NEXT_PUBLIC_SUPABASE_ANON_KEY"
  type  = "SecureString"
  value = "dummy"

  lifecycle {
    ignore_changes = [value]
  }
}
resource "aws_ssm_parameter" "nextauth_secret" {
  name  = "/vercel-ai-chatbot/dev/NEXTAUTH_SECRET"
  type  = "SecureString"
  value = "dummy"

  lifecycle {
    ignore_changes = [value]
  }
}