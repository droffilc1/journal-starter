resource "aws_instance" "journal_db" {
  ami                    = "ami-0fb653ca2d3203ac1"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_a.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  user_data = templatefile("${path.module}/install_postgres.sh", {
    DB_PASSWORD = var.db_password
  })

  tags = {
    Name = "journal-db"
  }
}

