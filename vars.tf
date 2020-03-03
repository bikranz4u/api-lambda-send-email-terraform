# API GATEWAY
variable "apigw_settemplate" {
  type    = string
  default = "settemplate"

}

variable "apigw_send" {
  type    = string
  default = "api-lambda-send-email-ses"
}

# variable "api-lambda-send-email-ses" {
#   type = map
#   default = {
#     "name"      = "SetTemplate"
#     "subject"   = "Automated Email from Lambda"
#     "message"   = "Automated Email from Lambda body"
#     "FromEmail" = "emailuser@example.com" #Must be a SES verified email
#   }
# }



# LAMBDA FUNCTION
variable "lambda_send_email" {
  type    = string
  default = "serverless_send_email_api"
}
variable "lambda_set_template" {
  type    = string
  default = "set_template"
}
variable "fromEmail" {
  type    = string
  default = "bharadwaj.dvps@gmail.com"
}

# variable "toEmails" {
#   type    = list
#   default = ["user1@example.com", "user2@example.com", "user3@example.com"]
# }
#
# variable "ccEmails" {
#   type    = list
#   default = ["user4@example.com", "user5@example.com", "user6@example.com"]
# }

variable "cors_rule" {
  default = ""
}

#  USER PROFILE
variable "aws_credentials_file_path" {
  type    = string
  default = "~/.aws/credential"
}

variable "aws_profile_name" {
  type    = string
  default = "bharath"
}


# GLOBAL
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "accountId" {
  type    = string
  default = "305496103131"
}
