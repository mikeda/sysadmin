<?php

$ks_config = file_get_contents('default.cfg');

echo preg_replace(
  "/^network .*/m",
  "network --bootproto=static --device=eth0 "
    . "--ip={$_GET['ip']} "
    . "--netmask=255.255.255.0 "
    . "--gateway=192.168.1.1 "
    . "--nameserver=8.8.8.8 "
    . "--ipv6=auto --activate "
    . "--hostname {$_GET['hostname']}",
  $ks_config
);
