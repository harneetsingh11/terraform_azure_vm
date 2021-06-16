resource "null_resource" "name" {
provisioner "remote-exec" {
    inline = [
      "yum install httpd -y",
      "echo hello world > index.html",
      "systemctl enable httpd --now",
      "systemctl stop firewalld",
      " yum install vsftpd* -y ",
      "setsebool -P ftpd_anon_write  on",
      "setsebool -P  ftpd_connect_all_unreserved on",
      "setsebool -P ftpd_connect_db  on",
      "setsebool -P ftpd_full_access on",
      "setsebool -P ftpd_use_cifs  on",
      "setsebool -P  ftpd_use_fusefs on",
      "setsebool -P  ftpd_use_nfs on",
      "setsebool -P ftpd_use_passive_mode  on",
      "setsebool -P httpd_can_connect_ftp  on",
      "setsebool -P  httpd_enable_ftp_server on",
      "setsebool -P tftp_anon_write  on",
      "setsebool -P tftp_home_dir  on",      
    ]
      connection {
    type     = "ssh"
    user     = "root"
    password = "Vrockpokey@11"
    host = "${azurerm_public_ip.public-ip.ip_address}"
}
}
provisioner "file" {
  source      = "C:/Users/user/Desktop/vsftpd.conf>"
  destination = "/etc/vsftpd"
   connection {
    type     = "ssh"
    user     = "root"
    password = "Vrockpokey@11"
    host = "${azurerm_public_ip.public-ip.ip_address}"
}
}

  provisioner "remote-exec" {
    inline = ["systemctl enable vsftpd --now"]
     connection {
    type     = "ssh"
    user     = "root"
    password = "Vrockpokey@11"
    host = "${azurerm_public_ip.public-ip.ip_address}"
  }
  }
}
