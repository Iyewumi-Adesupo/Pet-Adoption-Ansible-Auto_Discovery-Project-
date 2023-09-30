resource "aws_iam_user" "Susan_terraform" {
    name = "ansible-user"
}
resource "aws_iam_access_key" "user-access-key" {
  user = aws_iam_user.Susan_terraform.name
}
resource "aws_iam_group" "Dev-team" {
  name = "ansible-group"
}
resource "aws_iam_user_group_membership" "Susan_terraform" {
  user = aws_iam_user.Susan_terraform.name
  groups = [aws_iam_group.Dev-team.name]
}
resource "aws_iam_group_policy_attachment" "policy" {
  group = aws_iam_group.Dev-team.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
