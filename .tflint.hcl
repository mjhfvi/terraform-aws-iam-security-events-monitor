tflint {
  required_version = ">= 0.50"
}

config {
#   format = "compact"
#   plugin_dir = "~/.tflint.d/plugins"

  call_module_type = "local"
  force = false
  disabled_by_default = false

#   ignore_module = {
#     "terraform-aws-modules/vpc/aws"            = true
#     "terraform-aws-modules/security-group/aws" = true
#   }

#   varfile = ["example1.tfvars", "example2.tfvars"]
#   variables = ["foo=bar", "bar=[\"baz\"]"]
}

plugin "aws" {
  enabled = true
  version = "0.37.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_map_duplicate_keys" {
  enabled = false
}

rule "terraform_required_providers" {
  enabled = false
}
