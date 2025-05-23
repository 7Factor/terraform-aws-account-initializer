data "aws_iam_policy_document" "assume_developer" {
  count = var.developer_role_enabled ? 1 : 0

  dynamic "statement" {
    for_each = var.developer_access_from

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

resource "aws_iam_role" "developer" {
  count = var.developer_role_enabled ? 1 : 0

  name = var.developer_role_name

  assume_role_policy = data.aws_iam_policy_document.assume_developer[0].json
}

resource "aws_iam_policy" "developer" {
  count = var.developer_role_enabled ? 1 : 0

  name   = var.developer_policy_name
  policy = var.developer_policy_json
}

resource "aws_iam_policy_attachment" "developer" {
  count = var.developer_role_enabled ? 1 : 0

  name       = "${var.developer_policy_name}-attachment"
  roles      = [aws_iam_role.developer[0].name]
  policy_arn = aws_iam_policy.developer[0].arn
}
