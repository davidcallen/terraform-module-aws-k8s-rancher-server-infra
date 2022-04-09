//resource "aws_iam_role" "rancher-server" {
//  name               = "${var.environment.resource_name_prefix}-rancher-server"
//  assume_role_policy = <<EOF
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Effect": "Allow",
//      "Principal": {
//        "AWS": "arn:aws:iam::${var.environment.account_id}:root"
//      },
//      "Action": "sts:AssumeRole"
//    }
//  ]
//}
//EOF
//
//  tags = merge(var.global_default_tags, var.environment.default_tags, {
//    Name = "${var.environment.resource_name_prefix}-rancher-server"
//  })
//}
//resource "aws_iam_role_policy_attachment" "rancher-server" {
//  role       = aws_iam_role.rancher-server.name
//  policy_arn = aws_iam_policy.rancher-server.arn
//}
data "aws_iam_user" "rancher-server" {
  user_name = "rancher"
}
resource "aws_iam_user_policy_attachment" "rancher-server" {
  user       = data.aws_iam_user.rancher-server.user_name
  policy_arn = aws_iam_policy.rancher-server.arn
}
resource "aws_iam_policy" "rancher-server" {
  name        = "${var.environment.resource_name_prefix}-rancher-server"
  description = "Allow Rancher server to manipulate AWS resources to create new clusters, add nodes etc..."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "EC2keyPairsAllow",
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:Describe*",
                "ec2:ImportKeyPair",
                "ec2:CreateKeyPair",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:DeleteKeyPair",
                "ec2:ModifyInstanceMetadataOptions"
            ],
            "Resource": "*"
        },
        {
            "Sid": "EC2passRoleAllow",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole",
                "ec2:RunInstances"
            ],
            "Resource": [
                "arn:aws:ec2:${var.aws_region}::image/ami-*",
                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:instance/*",
                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:placement-group/*",
                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:volume/*",
                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:subnet/*",
                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:key-pair/*",
                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:network-interface/*",
                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:security-group/*"
            ]
        },
        {
            "Sid": "EC2startStopAllow",
            "Effect": "Allow",
            "Action": [
                "ec2:RebootInstances",
                "ec2:TerminateInstances",
                "ec2:StartInstances",
                "ec2:StopInstances"
            ],
            "Resource": "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:instance/*"
        },
        {
            "Sid": "IAMAllow",
            "Effect": "Allow",
            "Action": [
                "iam:ListRoles"
            ],
            "Resource": "arn:aws:iam::${var.environment.account_id}:role/*"
        }
    ]
}
EOF
}

//# Policy With PassRole  (needed if you want to use Kubernetes Cloud Provider or want to pass an IAM Profile to an instance)
//resource "aws_iam_policy" "rancher-server" {
//    name        = "${var.environment.resource_name_prefix}-rancher-server"
//    description = "Allow Rancher server to manipulate AWS resources to create new clusters, add nodes etc..."
//    policy      = <<EOF
//{
//    "Version": "2012-10-17",
//    "Statement": [
//        {
//            "Sid": "EC2keyPairsAllow",
//            "Effect": "Allow",
//            "Action": [
//                "ec2:AuthorizeSecurityGroupIngress",
//                "ec2:Describe*",
//                "ec2:ImportKeyPair",
//                "ec2:CreateKeyPair",
//                "ec2:CreateSecurityGroup",
//                "ec2:CreateTags",
//                "ec2:DeleteKeyPair",
//                "ec2:ModifyInstanceMetadataOptions"
//            ],
//            "Resource": "*"
//        },
//        {
//            "Sid": "EC2passRoleAllow",
//            "Effect": "Allow",
//            "Action": [
//                "iam:PassRole",
//                "ec2:RunInstances"
//            ],
//            "Resource": [
//                "arn:aws:ec2:${var.aws_region}::image/ami-*",
//                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:instance/*",
//                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:placement-group/*",
//                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:volume/*",
//                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:subnet/*",
//                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:key-pair/*",
//                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:network-interface/*",
//                "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:security-group/*",
//                "arn:aws:iam::${var.environment.account_id}:role/${aws_iam_role.rancher-server.name}"
//            ]
//        },
//        {
//            "Sid": "EC2startStopAllow",
//            "Effect": "Allow",
//            "Action": [
//                "ec2:RebootInstances",
//                "ec2:TerminateInstances",
//                "ec2:StartInstances",
//                "ec2:StopInstances"
//            ],
//            "Resource": "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:instance/*"
//        }
//    ]
//}
//EOF
//}

# IAM Policy if want to allow encrypted EBS volumes
//        {
//          "Effect": "EC2encryptedVolumeAllow",
//          "Action": [
//            "kms:Decrypt",
//            "kms:GenerateDataKeyWithoutPlaintext",
//            "kms:Encrypt",
//            "kms:DescribeKey",
//            "kms:CreateGrant",
//            "ec2:DetachVolume",
//            "ec2:AttachVolume",
//            "ec2:DeleteSnapshot",
//            "ec2:DeleteTags",
//            "ec2:CreateTags",
//            "ec2:CreateVolume",
//            "ec2:DeleteVolume",
//            "ec2:CreateSnapshot"
//          ],
//          "Resource": [
//            "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:volume/*",
//            "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:instance/*",
//            "arn:aws:ec2:${var.aws_region}:${var.environment.account_id}:snapshot/*",
//            "arn:aws:kms:${var.aws_region}:${var.environment.account_id}:key/KMS_KEY_ID"
//          ]
//        },
//        {
//          "Effect": "EC2describeVolumesAllow",
//          "Action": [
//            "ec2:DescribeInstances",
//            "ec2:DescribeTags",
//            "ec2:DescribeVolumes",
//            "ec2:DescribeSnapshots"
//          ],
//          "Resource": "*"
//        }
//    ]
//}
//EOF
//}
