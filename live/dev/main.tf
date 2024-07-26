
module "default_vpc" {
  source = "../../modules/default_vpc"
}


module "main_vpc" {
  source         = "../../modules/vpc"
  project_name   = var.project_name
  env_name       = var.env_name
  cidr_block     = var.vpccidr
  prisub1cidr    = var.prisub1cidr
  prisub2cidr    = var.prisub2cidr
  prisub3cidr    = var.prisub3cidr
  pubsub1cidr    = var.pubsub1cidr
  pubsub2cidr    = var.pubsub2cidr
  pubsub3cidr    = var.pubsub3cidr
  region         = var.region
  reuse_loggroup = var.reuse_SSM_log_group
}

module "ssm_policy" {
  source            = "../../modules/ssm"
  project_name      = var.project_name
  env_name          = var.env_name
  ssmenabled_policy = var.ssmenabled_policy
  ssm_env           = var.ssm_env
}

module "bloginstance_config" {
  source       = "../../modules/config"
  project_name = var.project_name
  env_name     = var.env_name
}

module "ec2_ebs_volume" {
  source       = "../../modules/ebs_volume"
  project_name = var.project_name
  env_name     = var.env_name
  region       = var.region
  type         = var.ebs_volume_type
  size         = var.ebs_volumes_size
}



module "ec2_instance" {
  source                      = "../../modules/ec2"
  project_name                = var.project_name
  ssm_env                     = var.ssm_env
  env_name                    = var.env_name
  cidr_block                  = var.vpccidr
  ec2_instance_type           = var.ec2_instance_type
  vpc_id                      = module.main_vpc.vpc_id
  ami_id                      = var.ec2_ami_id
  subnet_id_public_01         = module.main_vpc.subnet_pub_01
  subnet_id_public_02         = module.main_vpc.subnet_public_02
  subnet_id_public_03         = module.main_vpc.subnet_public_03
  subnet_id_private           = module.main_vpc.subnet_private_01
  ssh_secret_store            = module.bloginstance_config.ssh_secret_store
  keypair                     = module.bloginstance_config.keypair
  require_alb                 = var.require_alb
  ebs_volume_id               = module.ec2_ebs_volume.ebs_volume_id
  instance_ssm_cloudwatch_arn = module.ssm_policy.instance_ssm_cloudwatch_arn
  certificate_arn             = var.certificate_arn
  tag_app_name                = var.tag_app_name
}

module "bloginstance_db" {
  source                  = "../../modules/rds"
  project_name            = var.project_name
  env_name                = var.env_name
  ec2_instance_sg_id      = module.ec2_instance.ec2_instance_sg_id
  vpc_id                  = module.main_vpc.vpc_id
  dbsubnet_01             = module.main_vpc.subnet_pub_01
  dbsubnet_02             = module.main_vpc.subnet_public_02
  rds_snapshot_identifier = var.rds_snapshot_identifier
  tagname                 = var.db_tag_app_name
}
