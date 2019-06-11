<?php
function myguten_enqueue() {
    wp_enqueue_script(
        'myguten-script',
        plugins_url( 'cta.js', __FILE__ ),
        array( 'wp-blocks' )
    );
}
add_action( 'enqueue_block_editor_assets', 'myguten_enqueue' );

function myguten_stylesheet() {
    wp_enqueue_style( 'myguten-style', plugins_url( 'cta.css', __FILE__ ) );
}
add_action( 'enqueue_block_assets', 'myguten_stylesheet' );
