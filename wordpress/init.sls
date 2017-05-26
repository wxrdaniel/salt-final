clear-www:
  file.absent:
    - name: /var/www/index.html

get_wordpress:
  cmd.run:
    - name: 'wget -O latest.tar.gz http://wordpress.org/latest.tar.gz && tar xzf latest.tar.gz'
    - cwd: /tmp/
    - unless: cat /var/www/wp-config.php

wp_user:
  mysql_user.present:
    - name: wordpress
    - host: localhost
    - password: password

wp_db:
  mysql_database.present:
    - name: wordpress

wp_grants:
  mysql_grants.present:
    - grant: ALL
    - database: localhost.*
    - user: wordpress

wp_config:
  file.copy:
    - source: /tmp/wordpress/wp-config-sample.php
    - name: /tmp/wordpress/wp-config.php

wp_set_dbname:
  file.replace:
    - name: /tmp/wordpress/wp-config.php
    - pattern: 'database_name_here'
    - repl: wordpress

wp_set_dbuser:
  file.replace:
    - name: /tmp/wordpress/wp-config.php
    - pattern: 'username_here'
    - repl: 'wordpress'

wp_set_dbpwd:
  file.replace:
    - name: /tmp/wordpress/wp-config.php
    - pattern: 'password_here'
    - repl: 'password'

wp_copy:
  cmd.run:
    - name: 'cp -r /tmp/wordpress/* /var/www/'
    - unless: cat /var/www/wp-config.php
