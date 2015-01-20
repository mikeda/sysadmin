#!/bin/bash

useradd mikeda

mkdir /home/mikeda/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAqLPNuLw3j9qR6wxt8JUxN8X7JauJPHa6zrRXB6rjRPsAiXuvfjWgzXuZ0k4ABSYy9mMfudIBSLjhGn0FQP7FDP6JthVAboTUBNRFWHmgKX1430Djs74r6/2EKZtDQhvXwwBsq7jCKVFxfDw9j8A2Cjn9ESarLxuUxbnD3bM7+qo5XwkDlpbn0hFEZvcwmt/DxxnUx5jiNJdl9SjeP8m/WteZXTqHm0X9AACx3GyHcvcm/9LELvOzJ9Q42i7rpV/DHwqtOLq9KUjGGkQqYhHzwN6CXP9Torw21Z5wTHxNNY8m4+YYsxT5OSOqgyeypYBKi8+it1Bbn0UzOu78rrAJbw== mikeda" > /home/mikeda/.ssh/authorized_keys

chown -R mikeda.mikeda /home/mikeda/.ssh
chmod 700 /home/mikeda/.ssh
chmod 600 /home/mikeda/.ssh/authorized_keys

echo "mikeda ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/mikeda

sed -i '/^Defaults.*requiretty$/s/^/#/' /etc/sudoers
