resource "aws_instance" "jenkins" {
    ami = "ami-0360c520857e3138f"
    instance_type = "t2.medium"
    subnet_id = var.public_subnet_id
    key_name = var.key_name
    vpc_security_group_ids = [var.sg_id]

    tags = {
      Name = "${var.project_name}-jenkins"
    }
}

resource "aws_instance" "app-server" {
    ami = "ami-0360c520857e3138f"
    instance_type = var.instance_type
    subnet_id = var.private_subnet_id 
    key_name = var.key_name
    vpc_security_group_ids = [var.sg_id]

    tags = {
        Name = "${var.project_name}-app"
    }  
}