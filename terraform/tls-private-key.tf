resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh-private-key" {
    content     = tls_private_key.example.private_key_pem
    filename = "${path.module}/id_rsa"
    file_permission = "0600"
}