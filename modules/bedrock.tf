# data "aws_bedrock_foundation_model" "example" {
#   model_id = "amazon.titan-text-express-v1"
# }

# resource "aws_bedrock_custom_model" "example" {
#   custom_model_name     = "example-model"
#   job_name              = "example-job-1"
#   base_model_identifier = data.aws_bedrock_foundation_model.example.model_arn
#   role_arn              = aws_iam_role.example.arn

#   hyperparameters = {
#     "epochCount"              = "1"
#     "batchSize"               = "1"
#     "learningRate"            = "0.005"
#     "learningRateWarmupSteps" = "0"
#   }

#   output_data_config {
#     s3_uri = "s3://${aws_s3_bucket.output.id}/data/"
#   }

#   training_data_config {
#     s3_uri = "s3://${aws_s3_bucket.training.id}/data/train.jsonl"
#   }
# }

# # Create IAM Role for Bedrock Access
# resource "aws_iam_role" "bedrock_role" {
#   name = "BedrockInferenceRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect    = "Allow"
#       Principal = { Service = "bedrock.amazonaws.com" }
#       Action    = "sts:AssumeRole"
#     }]
#   })
# }

# # Attach Policies to Bedrock IAM Role
# resource "aws_iam_policy_attachment" "bedrock_policy" {
#   name       = "BedrockPolicyAttachment"
#   roles      = [aws_iam_role.bedrock_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
# }

# # Create OpenSearch Serverless Domain (Low-Cost)
# resource "aws_opensearchserverless_collection" "rag_search" {
#   name = "rag-search"
#   type = "VECTORSEARCH" # Enables vector search for embeddings
# }

# # Create Lambda Function to Handle RAG Queries
# # resource "aws_lambda_function" "rag_lambda" {
# #   function_name = "bedrock-rag-query"
# #   role          = aws_iam_role.bedrock_role.arn
# #   runtime       = "python3.9"
# #   handler       = "lambda_function.lambda_handler"

# #   filename      = "lambda_function.zip"  # Upload the Lambda function
# #   timeout       = 10  # Keep it lightweight

# #   environment {
# #     variables = {
# #       OPENSEARCH_ENDPOINT = aws_opensearchserverless_collection.rag_search.arn
# #       BEDROCK_MODEL       = "anthropic.claude-v2"
# #     }
# #   }
# # }

# # IAM Permissions for Lambda to Call Bedrock & OpenSearch
# resource "aws_iam_role_policy" "lambda_bedrock_policy" {
#   role = aws_iam_role.bedrock_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "bedrock:InvokeModel"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "aoss:APIAccessAll"
#         ]
#         Resource = aws_opensearchserverless_collection.rag_search.arn
#       }
#     ]
#   })
# }
