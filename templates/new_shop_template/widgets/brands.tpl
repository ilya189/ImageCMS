<div class="frame_brand carousel_js">
<div class="container p_r">
    <div class="carousel">
        <ul class="items">
            {$brands = array_slice($brands,0,6)}
            {foreach $brands as $brand}
                <li>
                    <a href="{shop_url($brand.full_url)}">
                        <span class="helper"></span>
                        <img src="{media_url($brand.img_fullpath)}" title="{$brand.name}"/>
                    </a>
                </li>
            {/foreach}
        </ul>
    </div>
    <button class="btn_brand btn_prev"></button>
    <button class="btn_brand btn_next"></button>
</div>