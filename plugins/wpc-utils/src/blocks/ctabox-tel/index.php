<?php
/**
 *
 */
defined( 'ABSPATH' ) || exit;

/**
 * Registers all block assets so that they can be enqueued through Gutenberg in
 * the corresponding context.
 *
 * Passes translations to JavaScript.
 */
function ctabox_tel_register_block() {
    // Gutenberg is not active.
    if ( ! function_exists( 'register_block_type' ) ) {
        return;
    }

    // load js
    wp_register_script(
        'ctabox-tel',
        plugins_url( 'build/index.js', __FILE__ ),
        array( 'wp-blocks', 'wp-element', 'wp-editor', 'wp-components' ),
        filemtime( plugin_dir_path( __FILE__ ) . 'build/index.js' )
    );
    wp_register_style(
        'ctabox-tel',
        plugins_url( 'build/index.css', __FILE__ ),
        array(),
        filemtime( plugin_dir_path( __FILE__ ) . 'build/index.css' )
    );
    register_block_type( 'wpc-utils/ctabox-tel',
        array(
            'editor_script' => 'ctabox-tel',
            'style' => 'ctabox-tel',
        )
    );
}
add_action( 'init', 'ctabox_tel_register_block' );

/**
 * Managing block categories
 */
function utils_block_categories( $categories, $post ) {
    if ( $post->post_type !== 'post' ) { return $categories; }

    return array_merge(
        $categories,
        array(
            array(
                'slug' => 'wpc-category',
                'title' => 'Custom Blocks',
                'icon'  => 'wordpress',
            ),
        )
    );
}
add_filter( 'block_categories', 'utils_block_categories', 10, 2 );
