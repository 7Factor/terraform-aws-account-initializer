resource "aws_iam_openid_connect_provider" "github_idp" {
  count = var.deployment_role_enabled ? 1 : 0

  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

data "aws_iam_policy_document" "assume_deployment" {
  count = var.deployment_role_enabled ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_idp[0].arn]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
      "sts:TagSession",
    ]

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for repo in var.deploy_from_github_repos : "repo:${repo}:*"]
    }
  }
}

resource "aws_iam_role" "deployment" {
  count = var.deployment_role_enabled ? 1 : 0

  name = var.deployment_role_name

  assume_role_policy = data.aws_iam_policy_document.assume_deployment[0].json
}

resource "aws_iam_policy" "deployment" {
  count = var.deployment_role_enabled ? 1 : 0

  name   = var.deployment_policy_name
  policy = var.deployment_policy_json
}

resource "aws_iam_policy_attachment" "deployment" {
  count = var.deployment_role_enabled ? 1 : 0

  name = "${var.deployment_policy_name}-attachment"
  roles = flatten([aws_iam_role.deployment[0].name,
  var.developer_inherits_deployment_policy && var.developer_role_enabled ? [aws_iam_role.developer[0].name] : []])
  policy_arn = aws_iam_policy.deployment[0].arn
}
