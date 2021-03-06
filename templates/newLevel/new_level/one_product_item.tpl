{foreach $products as $p}
    {$Comments = $CI->load->module('comments')->init($p)}
    <li>
        <a href="{shop_url('product/' . $p->getUrl())}" class="frame-photo-title">
            <span class="photo-block">
                <span class="helper"></span>
                <img data-original="{echo $p->firstVariant->getMediumPhoto()}"
                     src="{$THEME}images/blank.gif"
                     alt="{echo ShopCore::encode($p->firstVariant->getName())}"
                     class="vimg lazy"/>
                {$discount = 0}
                {if $p->hasDiscounts()}
                    {$discount = $p->firstVariant->getvirtual('numDiscount')/$p->firstVariant->toCurrency()*100}
                {/if}
                {promoLabel($p->getAction(), $p->getHot(), $p->getHit(), $discount)}
            </span>
            <span class="title">{echo ShopCore::encode($p->getName())}</span>
        </a>
        <div class="description">
            {if !$widget && !$defaultItem}
                <span class="frame-variant-name-code">
                    {$hasCode = $p->firstVariant->getNumber() == ''}
                    <span class="frame-variant-code" {if $hasCode}style="display:none;"{/if}>Артикул:
                        <span class="code">
                            {if !$hasCode}
                                {trim($p->firstVariant->getNumber())}
                            {/if}
                        </span>
                    </span>
                    {$hasVariant = $p->firstVariant->getName() == ''}
                    <span class="frame-variant-name" {if $hasVariant}style="display:none;"{/if}>Вариант:
                        <span class="code">
                            {if !$hasVariant}
                                {trim($p->firstVariant->getName())}
                            {/if}
                        </span>
                    </span>
                </span>
            {/if}
            {if !$vertical}
                {if $Comments[$p->getId()][0] != '0' && $p->enable_comments}
                    <div class="frame-star f-s_0">
                        {$CI->load->module('star_rating')->show_star_rating($p)}
                        <a href="{shop_url('product/'.$p->url.'#comment')}" class="count-response">
                            {$Comments[$p->getId()]}
                        </a>
                    </div>
                {/if}
            {/if}
            <div class="frame-prices f-s_0">
                <!-- Check for discount-->
                {$oldoprice = $p->getOldPrice() && $p->getOldPrice() != 0}
                {$hasDiscounts = $p->hasDiscounts()}
                {if $hasDiscounts}
                    <span class="price-discount">
                        <span>
                            <span class="price priceOrigVariant">{echo $p->firstVariant->toCurrency('OrigPrice')}</span>
                            <span class="curr">{$CS}</span>
                        </span>
                    </span>
                {/if}
                {if $oldoprice && !$hasDiscounts}
                    <span class="price-discount">
                        <span>
                            <span class="price priceOrigVariant">{echo $p->getOldPrice()}</span>
                            <span class="curr">{$CS}</span>
                        </span>
                    </span>
                {/if}
                {if $p->firstVariant->toCurrency() > 0}
                    <span class="current-prices f-s_0">
                        <span class="price-new">
                            <span>
                                <span class="price priceVariant">{echo $p->firstVariant->toCurrency()}</span>
                                <span class="curr">{$CS}</span>
                            </span>
                        </span>
                        {if $NextCSId != null}
                            <span class="price-add">
                                <span>
                                    (<span class="price addCurrPrice">{echo $p->firstVariant->toCurrency('Price',$NextCSId)}</span>
                                    <span class="curr-add">{$NextCS}</span>)
                                </span>
                            </span>
                        {/if}
                    </span>
                {/if}
            </div>
            {$variants = $p->getProductVariants()}
            {if !$widget && !$defaultItem}
                {if count($variants) > 1}
                    <div class="check-variant-catalog">
                        <div class="lineForm">
                            <select id="сVariantSwitcher_{echo $p->firstVariant->getId()}" name="variant">
                                {foreach $variants as $key => $pv}
                                    {if $pv->getName()}
                                        {$name = ShopCore::encode($pv->getName())}
                                    {else:}
                                        {$name = ShopCore::encode($p->getName())}
                                    {/if}
                                    <option value="{echo $pv->getId()}" title="{echo $name}">
                                        {echo $name}
                                    </option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                {/if}
            {/if}

            <!--            End. Price-->
            <div class="funcs-buttons">
                <!-- Start. Collect information about Variants, for future processing -->
                {foreach $variants as $key => $pv}
                    {$widgetWOV = ($widget && $key < 1) || !$widget}
                    {$defoultWOV = ($defaultItem && $key < 1) || !$defaultItem}
                    {if $widgetWOV || $defoultWOV}
                        {if $pv->getStock() > 0}
                            <div class="frame-count-buy variant_{echo $pv->getId()} variant" {if $key != 0}style="display:none"{/if}>
                                {if !widget && !$defaultItem}
                                    <div class="frame-count">
                                        <div class="number" data-title="количество на складе {echo $pv->getstock()}" data-prodid="{echo $p->getId()}" data-varid="{echo $pv->getId()}" data-rel="frameplusminus">
                                            <div class="frame-change-count">
                                                <div class="btn-plus">
                                                    <button type="button">
                                                        <span class="icon-plus"></span>
                                                    </button>
                                                </div>
                                                <div class="btn-minus">
                                                    <button type="button">
                                                        <span class="icon-minus"></span>
                                                    </button>
                                                </div>
                                            </div>
                                            <input type="text" value="1" data-rel="plusminus" data-title="только цифры" data-min="1" data-max="{echo $pv->getstock()}">
                                        </div>
                                    </div>
                                {/if}
                                <div class="btn-buy">
                                    <button
                                        {$discount = 0}
                                        {if $hasDiscounts}
                                            {$discount = $pv->getvirtual('numDiscount')/$pv->toCurrency()*100}
                                        {/if}
                                        class="btnBuy infoBut"
                                        type="button"
                                        data-id="{echo $pv->getId()}"
                                        data-prodid="{echo $p->getId()}"
                                        data-varid="{echo $pv->getId()}"
                                        data-price="{echo $pv->toCurrency()}"
                                        data-name="{echo ShopCore::encode($p->getName())}"
                                        data-vname="{echo ShopCore::encode($pv->getName())}"
                                        data-maxcount="{echo $pv->getstock()}"
                                        data-number="{echo trim($pv->getNumber())}"
                                        data-mediumImage="{echo $pv->getMediumPhoto()}"
                                        data-img="{echo $pv->getSmallPhoto()}"
                                        data-url="{echo shop_url('product/'.$p->getUrl())}"
                                        data-price="{echo $pv->toCurrency()}"
                                        data-origPrice="{if $p->hasDiscounts()}{echo $pv->toCurrency('OrigPrice')}{/if}"
                                        data-addPrice="{echo $pv->toCurrency('Price',1)}"
                                        data-prodStatus='{echo json_encode(promoLabelBtn($p->getAction(), $p->getHot(), $p->getHit(), $discount))}'>
                                        <span class="icon_cleaner icon_cleaner_buy"></span>
                                        <span class="text-el">{lang('s_buy')}</span>
                                    </button>
                                </div>
                            </div>
                        {else:}
                            <div class="btn-not-avail variant_{echo $pv->getId()} variant" {if $key != 0}style="display:none"{/if}>
                                <button
                                    class="infoBut"
                                    type="button"
                                    data-drop=".drop-report"
                                    data-source="/shop/ajax/getNotifyingRequest"
                                    
                                    data-id="{echo $pv->getId()}"
                                    data-prodid="{echo $p->getId()}"
                                    data-varid="{echo $pv->getId()}"
                                    data-price="{echo $pv->toCurrency()}"
                                    data-name="{echo ShopCore::encode($p->getName())}"
                                    data-vname="{echo ShopCore::encode($pv->getName())}"
                                    data-maxcount="{echo $pv->getstock()}"
                                    data-number="{echo trim($pv->getNumber())}"
                                    data-mediumImage="{echo $pv->getMediumPhoto()}"
                                    data-img="{echo $pv->getSmallPhoto()}"
                                    data-url="{echo shop_url('product/'.$p->getUrl())}"
                                    <span class="icon-but"></span>
                                    <span class="text-el">{lang('s_message_o_report')}</span>
                                </button>
                            </div>
                        {/if}
                    {/if}
                {/foreach}
            </div>
            {if !$widget && !$defaultItem}
                <div class="p_r frame-without-top">
                    <div class="frame-wish-compare-list no-vis-table">
                        {if !$compare}
                            <!-- compare buttons ----------------------->
                            <div class="btn-compare">
                                <button class="toCompare"
                                        data-prodid="{echo $p->getId()}"
                                        type="button"
                                        data-title="{lang('s_add_to_compare')}"
                                        data-firtitle="{lang('s_add_to_compare')}"
                                        data-sectitle="{lang('s_in_compare')}"
                                        data-rel="tooltip">
                                    <span class="icon_compare"></span>
                                    <span class="text-el d_l">{lang('s_add_to_compare')}</span>
                                </button>
                            </div>
                            <!-- end of compare buttons ---------------->
                        {/if}
                        <!--                     Add to wishlist, if $CI->uri->segment(2) != "wish_list"-->
                        {if $CI->uri->segment(2) != "wish_list"}
                            <!-- Wish List buttons --------------------->
                            {foreach $variants as $key => $pv}
                                <!-- to wish list button -->
                                <div class="variant_{echo $pv->getId()} variant btn-wish" {if $key != 0}style="display:none"{/if}>
                                    <button class="toWishlist"
                                            data-price="{echo $pv->toCurrency()}"
                                            data-prodid="{echo $p->getId()}"
                                            data-varid="{echo $pv->getId()}"
                                            type="button"
                                            data-title="{lang('s_add_to_wish_list')}"
                                            data-firtitle="{lang('s_add_to_wish_list')}"
                                            data-sectitle="{lang('s_in_wish_list')}"
                                            data-rel="tooltip">
                                        <span class="icon_wish"></span>
                                        <span class="text-el d_l">{lang('s_add_to_wish_list')}</span>
                                    </button>
                                </div>
                            {/foreach}
                            <!-- end of Wish List buttons -------------->
                        {/if}
                    </div>
                </div>
            {/if}
            <!-- End. Collect information about Variants, for future processing -->
            {if !$widget && !$compare && !$defaultItem}
                <div class="p_r frame-without-top">
                    <div class="no-vis-table">
                        <!--Start. Description-->
                        {if trim($p->getShortDescription()) != ''}
                            <div class="short-desc">
                                {echo strip_tags($p->getShortDescription())}
                            </div>
                        {elseif $props = ShopCore::app()->SPropertiesRenderer->renderPropertiesInlineNew($p->getId(), 1)}
                            <div class="short-desc">
                                <p>{echo $props}</p>
                            </div>
                        {/if}
                        <!-- End. Description-->
                    </div>
                </div>
            {/if}
        </div>
        <!--        Start. Remove buttons if compare or wishlist-->
        {if $compare}
            <button type="button" class="icon_times deleteFromCompare" onclick="Shop.CompareList.rm({echo  $p->getId()}, this)"></button>
        {/if}
        {if $CI->uri->segment(2) == "wish_list" && ShopCore::$ci->dx_auth->is_logged_in() === true}
            <button data-drop_bak=".drop-enter" onclick="Shop.WishList.rm({echo $p->getId()}, this, {echo $p->getId()})" class="icon_times"></button>
        {/if}
        <!--        End. Remove buttons if compare or wishlist-->

        <div class="decor-element"></div>
    </li>
{/foreach}