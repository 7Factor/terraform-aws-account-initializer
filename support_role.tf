data "aws_iam_policy_document" "assume_support" {
  count = var.support_role_enabled ? 1 : 0

  dynamic "statement" {
    for_each = var.support_access_from

    content {
      sid = statement.value.sid

      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = "arn:aws:iam::${statement.value.account_id}:root"
      }

      actions = [
        "sts:AssumeRole",
        "sts:TagSession",
      ]

      dynamic "condition" {
        for_each = statement.value.conditional != null ? [statement.value.conditional] : []

        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = condition.value["values"]
        }
      }
    }
  }
}

resource "aws_iam_role" "support" {
  count = var.support_role_enabled ? 1 : 0

  name = var.support_role_name

  assume_role_policy = data.aws_iam_policy_document.assume_support[0].json
}

resource "aws_iam_policy" "support" {
  count = var.support_role_enabled ? 1 : 0

  name   = var.support_policy_name
  policy = var.support_policy_json
}

resource "aws_iam_policy_attachment" "support" {
  count = var.support_role_enabled ? 1 : 0

  name       = "${var.support_policy_name}-attachment"
  roles      = [aws_iam_role.support[0].name]
  policy_arn = aws_iam_policy.support[0].arn
}
