<?php
// Objetos tecnicos de T03. No constituyen contenido agricola de E03.
if (PHP_SAPI !== 'cli') { http_response_code(403); exit; }
$_SERVER['HTTP_HOST'] = 'cooperativa.internal';
$_SERVER['HTTPS'] = 'on';
require '/var/www/html/wp-load.php';
$accion = $argv[1] ?? '';
function fallo($mensaje) { fwrite(STDERR, $mensaje . "\n"); exit(1); }
if ($accion === 'crear') {
    $admins = get_users(['role'=>'administrator', 'number'=>1]);
    if (!$admins) fallo('No hay administrador tecnico.');
    wp_set_current_user($admins[0]->ID);
    $img=imagecreatetruecolor(480,160);
    $bg=imagecolorallocate($img,235,247,239);
    $fg=imagecolorallocate($img,24,71,42);
    imagefill($img,0,0,$bg);
    imagestring($img,5,24,48,'C03 persistencia Daniel',$fg);
    imagestring($img,4,24,86,'Imagen tecnica de prueba EIF431O',$fg);
    ob_start();imagepng($img);$png=ob_get_clean();imagedestroy($img);
    $upload=wp_upload_bits('t03-daniel-persistencia.png',null,$png);
    if ($upload['error']) fallo($upload['error']);
    $post=wp_insert_post([
        'post_title'=>'Prueba tecnica C03 de Daniel',
        'post_name'=>'prueba-tecnica-c03-daniel',
        'post_content'=>'Registro temporal de infraestructura. No es contenido agricola. '
            .'<img src="'.esc_url($upload['url']).'" alt="Prueba de persistencia C03">',
        'post_status'=>'publish','post_author'=>$admins[0]->ID,
    ],true);
    if (is_wp_error($post)) fallo($post->get_error_message());
    $media=wp_insert_attachment([
        'post_mime_type'=>'image/png','post_title'=>'Imagen tecnica C03 Daniel',
        'post_status'=>'inherit','post_author'=>$admins[0]->ID,
    ],$upload['file'],$post,true);
    if (is_wp_error($media)) fallo($media->get_error_message());
    require_once ABSPATH . 'wp-admin/includes/image.php';
    wp_update_attachment_metadata($media, wp_generate_attachment_metadata($media, $upload['file']));
    $estado=['post_id'=>$post,'media_id'=>$media,'title'=>get_the_title($post),
        'content_sha256'=>hash('sha256',get_post_field('post_content',$post)),
        'file'=>$upload['file'],'file_sha256'=>hash_file('sha256',$upload['file']),
        'url'=>get_permalink($post),'image_url'=>$upload['url']];
    echo wp_json_encode($estado,JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES)."\n";
} elseif ($accion === 'verificar' || $accion === 'borrador') {
    $estado=json_decode(getenv('COOP_T03_STATE')?:'',true);
    if (!$estado || empty($estado['post_id'])) fallo('Falta el estado anterior de T03.');
    $post=get_post((int)$estado['post_id']);
    $file=get_attached_file((int)$estado['media_id']);
    if (!$post || $post->post_title!==$estado['title']) fallo('Registro de BD diferente.');
    if (hash('sha256',$post->post_content)!==$estado['content_sha256']) fallo('Contenido diferente.');
    if (!$file || !is_file($file) || hash_file('sha256',$file)!==$estado['file_sha256']) fallo('Imagen diferente.');
    echo "PERSISTENCIA_OK post={$post->ID} media={$estado['media_id']} sha256={$estado['file_sha256']}\n";
    if ($accion==='borrador') {
        $r=wp_update_post(['ID'=>$post->ID,'post_status'=>'draft'],true);
        if (is_wp_error($r)) fallo($r->get_error_message());
        echo "OBJETO_TECNICO_EN_BORRADOR no cuenta para E03\n";
    }
} else { fallo('Usar crear, verificar o borrador.'); }
