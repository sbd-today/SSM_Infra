project_name            = "prj-blog"
env_name                = "dev"
region                  = "us-west-1"
ec2_instance_type       = "t2.small"
bucket_name             = "prj-blog-development-domain"
ssmenabled_policy       = "SSMSession_Development"
ssm_env                 = "development"
email_addresses         = ["rohit@safebydefault.org"]
vpccidr                 = "10.150.0.0/16"
pubsub1cidr             = "10.150.0.0/24"
pubsub2cidr             = "10.150.1.0/24"
pubsub3cidr             = "10.150.2.0/24"
prisub1cidr             = "10.150.3.0/24"
prisub2cidr             = "10.150.4.0/24"
prisub3cidr             = "10.150.5.0/24"
rds_snapshot_identifier = ""
certificate_arn         = ""
require_alb             = false
reuse_SSM_log_group     = true
ec2_ami_id              = "ami-043793be835902350"
tag_app_name            = "bloginstanceweb"
db_tag_app_name         = "mysql-db"
app_domain              = "nginx.sbd.today"
va_domain_cert_arn      = "arn:aws:acm:us-west-1:916145170329:certificate/c2a72026-b6fe-414d-9a8e-b488e43cf76a"