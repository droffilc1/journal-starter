resource "aws_instance" "postgres" {
  ami                         = "ami-0fb653ca2d3203ac1"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  associate_public_ip_address = true

  user_data_replace_on_change = true
  user_data                   = file("${path.module}/install_postgres.sh")

  tags = {
    Name = "journal-db"
  }
}
