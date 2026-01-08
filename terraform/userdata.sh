user_data = <<-EOF
#!/bin/bash
dnf update -y || apt update -y
dnf install -y python3 || apt install -y python3
EOF