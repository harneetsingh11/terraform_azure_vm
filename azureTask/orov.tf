resource "null_resource" "copy_web_pages" {
provisioner "file" {
  source      = "C:/Users/user/Desktop/index.html"
  destination = "/home/avi/index.html"
}
   connection {
    type     = "ssh"
    user     = "avi"
    password = "Vrockpokey@11"
    host = data.azurerm_public_ip.example.ip_address
}
}

resource "null_resource" "copy_config_file" {
provisioner "file" {
  source      = "C:/Users/user/Desktop/vsftpd.conf"
  destination = "/home/avi/vsftpd.conf"
}
   connection {
    type     = "ssh"
    user     = "avi"
    password = "Vrockpokey@11"
    host = data.azurerm_public_ip.example.ip_address
}
}

resource "null_resource" "conf_http_server" {
provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo echo hello world > /var/www/html/index.html",
      "sudo systemctl enable httpd --now",
      "sudo firewall-cmd --zone=public --add-port=80/tcp --permanent",
      "sudo firewall-cmd --reload",
      "sudo cp /home/avi/index.html  /var/www/html"] 
}
connection {
    type     = "ssh"
    user     = "avi"
    password = "Vrockpokey@11"
    host = data.azurerm_public_ip.example.ip_address
  }
}


resource "null_resource" "conf_ftp_server" {
provisioner "remote-exec" {
    inline = [
	"sudo dnf install vsftpd -y",
	"sudo systemctl start vsftpd",
	"sudo systemctl enable vsftpd --now",
  "sudo yum install ftp -y",
  "sudo adduser ftpuser",
  "echo avi6886 | sudo passwd ftpuser --stdin",
  "sudo mkdir -p /home/ftpuser/ftp_dir",
  "sudo chmod -R 750 /home/ftpuser/ftp_dir",
  "sudo chown -R ftpuser: /home/ftpuser/ftp_dir",
  "sudo cp /home/avi/vsftpd.conf  /etc/vsftpd/vsftpd.conf",
  "sudo systemctl restart vsftpd",
  "sudo firewall-cmd --permanent --add-port=20-21/tcp",
  "sudo firewall-cmd --permanent --add-port=49152-65535/tcp",
  "sudo firewall-cmd --reload"
  ]
}
connection {
    type     = "ssh"
    user     = "avi"
    password = "Vrockpokey@11"
    host = data.azurerm_public_ip.example.ip_address
  }
}



