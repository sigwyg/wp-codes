<?php
/**
 * Plugin Name: wpc-utils
 * Description: Util集
 * Version: 1.5
 * Author: sigywg
 */
define( 'DEBT_PLUGIN_DIR', __DIR__ );

require dirname( __FILE__ ) . '/src/admin.php';  // 管理画面周り
require dirname( __FILE__ ) . '/src/blocks/index.php';  // Gutenberg block

?>
