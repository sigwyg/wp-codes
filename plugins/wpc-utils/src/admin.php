<?php
/**
 * admin.php
 * - 管理画面まわり
 */


/**
 * ======================================================================================
 * 投稿一覧
 * ======================================================================================
 */

// 投稿一覧に投稿IDを表示する
add_filter('manage_posts_columns', function($defaults){
    $defaults['postid'] = '投稿ID';
    return $defaults;
});

// 投稿IDをtable bodyに描画
add_action( 'manage_posts_custom_column', 'add_posts_columns_postid_row', 10, 2 );
function add_posts_columns_postid_row($column_name, $post_id) {
    if ($column_name == 'postid') {
        echo $post_id;
    }
}

/**
 * 検索クエリを調整する
 * - WHERE句を弄って投稿IDを対象にする
 * - http://codex.wordpress.org/Plugin_API/Filter_Reference/posts_where
 */
add_filter('posts_where', 'cf_search_where');
function cf_search_where($where) {
    global $wpdb;
    if (is_search() && is_admin()) {
        $where = preg_replace(
            "/\(\s*".$wpdb->posts.".post_title\s+LIKE\s*(\'[^\']+\')\s*\)/",
            "(".$wpdb->posts.".post_title LIKE $1) OR (".$wpdb->posts.".id LIKE $1)", $where);
    }
    return $where;
}

?>
