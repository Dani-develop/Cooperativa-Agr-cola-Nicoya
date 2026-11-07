<?php
// C02/C03: ejecutar por CLI dentro del servicio wordpress, nunca por HTTP.
if (PHP_SAPI !== 'cli') { http_response_code(403); exit; }
define('WP_INSTALLING', true);
$_SERVER['HTTP_HOST'] = 'cooperativa.internal';
$_SERVER['HTTPS'] = 'on';
$_SERVER['SERVER_PORT'] = '443';
require '/var/www/html/wp-load.php';
require_once ABSPATH . 'wp-admin/includes/upgrade.php';
if (is_blog_installed()) {
    fwrite(STDERR, "WordPress ya esta instalado; no se reemplazan datos ni usuarios.\n");
    exit(2);
}
$user = getenv('WP_BOOT_ADMIN_USER');
$email = getenv('WP_BOOT_ADMIN_EMAIL');
$password = getenv('WP_BOOT_ADMIN_PASSWORD');
if (!$user || !is_email($email) || strlen((string)$password) < 16) {
    fwrite(STDERR, "Usuario/email validos y clave de al menos 16 caracteres requeridos.\n");
    exit(2);
}
wp_install('Cooperativa Agricola Nicoya', $user, $email, false, '', $password);
update_option('timezone_string', 'America/Costa_Rica');
update_option('permalink_structure', '/%postname%/');
flush_rewrite_rules();
printf("WORDPRESS_INSTALADO url=%s admin=%s\n", home_url(), $user);
