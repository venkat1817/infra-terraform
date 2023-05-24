#bastion.tfvars

region      = "ap-southeast-2"
cidr        = "10.1.0.0/16"
envname     = "dev"
pubsubnets  = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
privsubnets = ["10.1.3.0/24", "10.1.4.0/24", "10.1.5.0/24"]
datasubnets = ["10.1.6.0/24", "10.1.7.0/24", "10.1.8.0/24"]
azs         = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
ami         = "ami-0aab712d6363da7f9"
type        = "t2.micro"
