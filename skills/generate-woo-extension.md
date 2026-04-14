# /generate-woo-extension

Generate a WooCommerce extension (custom tab, checkout field, product type, etc.)

## Usage
```
/generate-woo-extension product-tab --name "Specifications" --fields "weight, dimensions, material"
/generate-woo-extension checkout-field --name "delivery_notes" --type "textarea"
/generate-woo-extension payment-gateway --name "Custom Pay"
```

## Instructions

### Product Tab
```php
<?php
declare(strict_types=1);

// Add custom product data tab
function {prefix}_add_product_tab(array $tabs): array {
    $tabs['{prefix}_tab'] = [
        'label'    => __('Specifications', '{textdomain}'),
        'target'   => '{prefix}_product_data',
        'priority' => 60,
    ];
    return $tabs;
}
add_filter('woocommerce_product_data_tabs', '{prefix}_add_product_tab');

// Tab content
function {prefix}_product_tab_content(): void {
    echo '<div id="{prefix}_product_data" class="panel woocommerce_options_panel">';
    woocommerce_wp_text_input([
        'id'          => '_{prefix}_weight',
        'label'       => __('Weight', '{textdomain}'),
        'desc_tip'    => true,
        'description' => __('Product weight in kg', '{textdomain}'),
    ]);
    echo '</div>';
}
add_action('woocommerce_product_data_panels', '{prefix}_product_tab_content');

// Save
function {prefix}_save_product_tab(int $post_id): void {
    $value = isset($_POST['_{prefix}_weight'])
        ? sanitize_text_field(wp_unslash($_POST['_{prefix}_weight']))
        : '';
    update_post_meta($post_id, '_{prefix}_weight', $value);
}
add_action('woocommerce_process_product_meta', '{prefix}_save_product_tab');
```

### Checkout Field
```php
// Add field to checkout
function {prefix}_add_checkout_field(array $fields): array {
    $fields['billing']['{prefix}_field'] = [
        'type'     => 'textarea',
        'label'    => __('Delivery Notes', '{textdomain}'),
        'required' => false,
        'priority' => 120,
    ];
    return $fields;
}
add_filter('woocommerce_checkout_fields', '{prefix}_add_checkout_field');

// Save field to order
function {prefix}_save_checkout_field(int $order_id): void {
    if (!empty($_POST['{prefix}_field'])) {
        $order = wc_get_order($order_id);
        $order->update_meta_data('_{prefix}_field',
            sanitize_textarea_field(wp_unslash($_POST['{prefix}_field']))
        );
        $order->save();
    }
}
add_action('woocommerce_checkout_update_order_meta', '{prefix}_save_checkout_field');
```

Rules:
- Use HPOS-compatible code (`$order->update_meta_data()` not `update_post_meta` for orders)
- Always sanitize and escape
- Use WooCommerce helper functions (`woocommerce_wp_text_input`, etc.)
- Use WooCommerce hooks, never modify templates directly
- Test with latest WooCommerce version
