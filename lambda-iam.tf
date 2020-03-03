resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.LambdaBasicExecutionRole.id

  policy = file("iam/LambdaBasicExecutionRole.json")
}

resource "aws_iam_role" "LambdaBasicExecutionRole" {
  name               = "lambda_role"
  assume_role_policy = file("iam/lambda_assume_role.json")
}
