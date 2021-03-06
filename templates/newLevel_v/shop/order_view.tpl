{#
/**
* @file Template. Displaying order view page;
* @partof main.tpl;
* Variables
*   $model : (object) instance of SOrders;
*    $model->getId() : return Order ID;
*    $model->getPaid() : return Order paid status;
*    $model->getSDeliveryMethods()->getName() : get Delivery method name;
*    $model->getOrderProducts() : return Ordered products list;
*    $model->getOrderKits() : return Ordered Kits list;
*    $model->getTotalPrice() : get aggregate ordered Products Price;
*    $model->getDeliveryPrice() : return delivery Price;
*    $model->getTotalPriceWithDelivery() : sum of Product and Delivery Prices;
*    $model->getTotalPriceWithGift() : difference of previous price (getTotalPriceWithDelivery) and gift certificate price;
* @updated 27 January 2013;
*/
#}

<div class="frame-inside page-order">
    <div class="container">
        {if $CI->session->flashdata('makeOrder') === true}
            <div class="f-s_0 title-order-view without-crumbs">
                <div class="frame-title">
                    <h1 class="d_i c_9">Спасибо, ваш заказ принят.</h1>
                </div>
            </div>
            <!-- Clear Cart locale Storage -->
            <script>{literal}$(document).ready(function() {
                Shop.Cart.clear();
                }){/literal}
            </script>
        {else:}
            <div class="f-s_0 title-order-view without-crumbs">
                <div class="frame-title">
                    <h1 class="d_i">Номер заказа:<span class="number-order">{echo $model->getId()}</span></h1>
                </div>
            </div>
        {/if}

        {$total = $model->getTotalPrice()}
        <!-- Start. Displays a information block about Order -->
        <div class="left-order">
            <div class="title-h3">Параметры заказа</div>
            <table class="table-info-order">
                <tr>
                    <th>Дата заказа</th>
                    <td>{date('d.m.Y, H:i:s.',$model->getDateCreated())} </td>
                </tr>
                <!-- Start. Render certificate -->
                {$giftCond = $model->getGiftCertKey() != null}
                {if $giftCond}
                    {$giftPrice = (float)$model->getGiftCertPrice()}
                    {$total -= $giftPrice}
                {else:}
                    {$giftPrice = 0}
                {/if}
                <!-- End. Render certificate -->

                <!-- Start. Delivery Method price -->
                {if (int)$model->getDeliveryPrice() > 0}
                    {$total = $total + $model->getDeliveryPrice()}
                {/if}
                <!-- End. Delivery Method price -->

                <tr>
                    <th>К оплате:</th>
                    <td>
                        <span class="frame-prices f-s_0">
                            <span class="current-prices f-s_0">
                                <span class="price-new">
                                    <span>
                                        <span class="price">{echo $total}</span>
                                        <span class="curr">{$CS}</span>
                                    </span>
                                </span>
                            </span>
                        </span>
                    </td>
                </tr>

                <!-- Start. Render payment button and payment description -->
                <tr>
                    <th>Способ оплаты:</th>
                    <td>
                        {if $model->getPaid() != true && $model->getTotalPriceWithGift() > 0}
                            {if $paymentMethod->getDescription()}
                                {echo ShopCore::t($paymentMethod->getDescription())}
                            {/if}
                        {/if}
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div class="frame-payment">
                            {echo ShopSettingsQuery::create()->filterByName('adminMessageOrderPage')->findOne()->getValue()}
                            {echo $paymentMethod->getPaymentForm($model)}
                        </div>
                    </td>
                </tr>
                <!-- End. Render payment button and payment description -->

                <!--                Start. Order status-->
                <tr>
                    <th>Статус заказа</th>
                    <td><span class="status-order">{echo SOrders::getStatusName('Id',$model->getStatus())}</span></td>
                </tr>
                <!--                End. Order status-->
                <!--                    Start. Paid or not-->
                <tr>
                    <th>Статус оплаты</th>
                    <td><span class="status-pay">{if $model->getPaid() == true}Оплачен{else:}Неоплачен{/if}</span></td>
                </tr>
                <!--                    End. Paid or not-->

                <!-- Start. Delivery Method name -->
                <tr>
                    <th>Способ доставки</th>
                    <td>
                        {if $model->getDeliveryMethod() > 0}
                            {echo $model->getSDeliveryMethods()->getName()}
                        {/if}
                    </td>
                </tr>
                <!-- End. Delivery Method name -->

            </table>
            <div class="title-h3">Данные покупателя</div>
            <!--                Start. User info block-->
            <table class="table-info-order">
                <tr>
                    <th>Имя:</th>
                    <td>{echo $model->getUserFullName()}</td>
                </tr>
                {if $model->getUserPhone()}
                <tr>
                    <th>Телефон:</th>
                    <td>{echo $model->getUserPhone()}</td>
                </tr>
                {/if}
                <tr>
                    <th>E-mail:</th>
                    <td>{echo $model->getUserEmail()}</td>
                </tr>
                {if $model->getUserEmail()}
                <tr>
                    <th>Город:</th>
                    <td>{echo $model->getUserEmail()}</td>
                </tr>
                {/if}
                {if $model->getUserDeliverTo()}
                    <tr>
                        <th>Адрес:</th>
                        <td>{echo $model->getUserDeliverTo()}</td>
                    </tr>
                {/if}
                {if $model->getUserComment()}
                    <tr>
                        <th>Комментарий к заказу</th>
                        <td>{echo $model->getUserComment()}</td>
                    </tr>
                {/if}
                <!--                End. User info block-->
            </table>
        </div>
        <!-- End. Displays a information block about Order -->
        <div class="right-order">
            <div class="frame-bask frame-bask-order">
                <div class="frame-bask-scroll">
                    <div class="frame-bask-main">
                        <div class="inside-padd">
                            <table class="table-order">
                                <tbody>
                                    <!-- for single product -->
                                    {foreach $model->getSOrderProductss() as $orderProduct}
                                        <tr class="items items-bask items-order cartProduct">
                                            <td class="frame-items">
                                                <!-- Start. Render Ordered Products -->            
                                                <a href="{shop_url('product/'.$orderProduct->getSProducts()->getUrl())}" class="frame-photo-title">
                                                    <span class="photo-block">
                                                        <span class="helper"></span>
                                                        <img alt="{echo ShopCore::encode($orderProduct->product_name)}" src="{echo $orderProduct->getSProducts()->firstVariant->getSmallPhoto()}">
                                                    </span>
                                                    <span class="title">{echo ShopCore::encode($orderProduct->product_name)}</span>
                                                </a>
                                                <div class="description">
                                                    <span class="frame-variant-name-code">
                                                    {if trim(ShopCore::encode($orderProduct->variant_name) != '')}<span class="frame-variant-name">{lang(s_variant)}: <span class="code">{echo ShopCore::encode($orderProduct->variant_name)}</span></span>{/if}
                                                </span>
                                                <span class="frame-prices">
                                                    <span class="current-prices f-s_0">
                                                        <span class="price-new">
                                                            <span>
                                                                <span class="price">{echo $orderProduct->getPrice()}</span>
                                                                <span class="curr">{$CS}</span>
                                                            </span>
                                                        </span>
                                                        <span class="price-add">
                                                            <span>
                                                                <span class="price">{echo $orderProduct->getPrice()}</span>
                                                                <span class="curr-add">{$NextCs}</span>
                                                            </span>
                                                        </span>
                                                    </span>
                                                </span>
                                                <div class="gen-sum-row">
                                                    <span class="s-t">Количество:</span>
                                                    <span class="count">{echo $orderProduct->getQuantity()}</span>
                                                    <span class="s-t">на сумму:</span>
                                                    <span class="frame-prices">
                                                        <span class="current-prices f-s_0">
                                                            <span class="price-new">
                                                                <span>
                                                                    <span class="price">{echo $orderProduct->getPrice()*$orderProduct->getQuantity()}</span>
                                                                    <span class="curr">{$CS}</span>
                                                                </span>
                                                            </span>
                                                            <span class="price-add">
                                                                <span>
                                                                    <span class="price">{echo $orderProduct->getPrice()*$orderProduct->getQuantity()}</span>
                                                                    <span class="curr-add">{$NextCs}</span>
                                                                </span>
                                                            </span>
                                                        </span>
                                                    </span>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                {/foreach}
                                <!-- end for single product -->
                                <!-- Start. Render Ordered kit products  -->
                                {foreach $model->getOrderKits() as $orderProduct}
                                    <tr class="row-kits">
                                        <td class="frame-items frame-items-kit">
                                            <ul class="items items-bask">
                                                <li>
                                                    <div class="frame-kit main-product">
                                                        <a href="{shop_url('product/' . $orderProduct->getKit()->getMainProduct()->getUrl())}" class="frame-photo-title">
                                                            <span class="photo-block">
                                                                <span class="helper"></span>
                                                                <img src="{echo $orderProduct->getKit()->getMainProduct()->firstVariant->getSmallPhoto()}" 
                                                                     alt="{echo ShopCore::encode($orderProduct->getKit()->getMainProduct()->getName())}"/>
                                                            </span>
                                                            <span class="title">{echo ShopCore::encode($orderProduct->getKit()->getMainProduct()->getName())}</span>
                                                        </a>
                                                        <div class="description">
                                                            <div class="frame-prices">
                                                                <span class="current-prices">
                                                                    <span class="price-new">
                                                                        <span>
                                                                            <span class="price">{echo $orderProduct->getKit()->getMainProduct()->getFirstVariant()->getPrice()}</span>
                                                                            <span class="curr">{$CS}</span>
                                                                        </span>
                                                                    </span>
                                                                    <span class="price-add">
                                                                        <span>
                                                                            <span class="price">{echo $orderProduct->getKit()->getMainProduct()->getFirstVariant()->getPrice()}</span>
                                                                            <span class="curr">{$NextCs}</span>
                                                                        </span>
                                                                    </span>
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    </div>
                                                </li>
                                                {foreach $orderProduct->getKit()->getShopKitProducts() as $key => $kitProducts}
                                                    <li>
                                                        <div class="next-kit">+</div>
                                                        <div class="frame-kit">
                                                            <a href="{shop_url('product/' . $kitProducts->getSProducts()->getUrl())}" class="frame-photo-title">
                                                                <span class="photo-block">
                                                                    <span class="helper"></span>
                                                                    <img src="{echo $kitProducts->getSProducts()->firstVariant->getSmallPhoto()}" 
                                                                         alt="{echo ShopCore::encode($kitProducts->getSProducts()->getName())}"/>
                                                                </span>
                                                                <span class="title">{echo ShopCore::encode($kitProducts->getSProducts()->getName())}</span>
                                                            </a>
                                                            <div class="description">
                                                                {/*<div class="frame-prices">
                                                                    <span class="current-prices">
                                                                        <span class="price-new">
                                                                            <span>
                                                                                <span class="price">{echo $kitProducts->getDiscountProductPrice()}</span>
                                                                                <span class="curr">{$CS}</span>
                                                                            </span>
                                                                        </span>
                                                                    </span>
                                                                </div>*/}
                                                            </div>
                                                        </div>
                                                    </li>
                                                {/foreach}
                                            </ul>
                                            <div class="gen-sum-row">
                                                <img src="{$THEME}images/kits_sum.png"/>
                                                <span class="s-t">Комплектов:</span>
                                                <span class="count">{echo $orderProduct->getQuantity()}</span>
                                                <span class="s-t">на сумму:</span>
                                                <span class="frame-prices">
                                                    <span class="current-prices f-s_0">
                                                        <span class="price-new">
                                                            <span>
                                                                <span class="price">{echo $orderProduct->getKit()->getTotalPrice()}</span>
                                                                <span class="curr">{$CS}</span>
                                                            </span>
                                                        </span>
                                                        <span class="price-add">
                                                            <span>
                                                                <span class="price">{echo $orderProduct->getKit()->getTotalPrice()}</span>
                                                                <span class="curr-add">{$NextCs}</span>
                                                            </span>
                                                        </span>
                                                    </span>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                {/foreach}
                                <!-- End. Render Ordered kit products  -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="frame-foot">
                <div class="header-frame-foot">
                    <div class="inside-padd">
                        <ul class="items items-order-gen-info">
                            <li>
                                <span class="s-t">Стоимость доставки:</span>
                                <span class="price-item">
                                    <span>
                                        <span class="price">{echo round($model->getDeliveryPrice())}</span>
                                        <span class="curr">{$CS}</span>
                                    </span>
                                </span>
                            </li>

                            <li>
                                <span class="s-t">Ваша текущая скидка:</span>
                                <span class="price-item">
                                    <span>
                                        <span class="text-discount current-discount">bla-bla</span>
                                    </span>
                                </span>
                            </li>
                            {if $giftCond}
                                <li>
                                    <span class="s-t">Подарочный сертификат:</span>
                                    <span class="price-item">
                                        <span class="text-discount">
                                            <span class="price">-{echo $giftPrice}</span>
                                            <span class="curr">{$CS}</span>
                                        </span>
                                    </span>
                                </li>
                            {/if}
                        </ul>
                        <!-- Start. Price block-->
                        <div class="gen-sum-order">
                            <span class="title">Итого к оплате:</span>
                            <span class="frame-prices f-s_0">
                                {if $giftCond}
                                    <span class="price-discount">
                                        <span>
                                            <span class="price">{echo $total+$giftPrice}</span>
                                            <span class="curr">{$CS}</span>
                                        </span>
                                    </span>
                                {/if}
                                <span class="current-prices f-s_0">
                                    <span class="price-new">
                                        <span>
                                            <span class="price">{echo $total}</span>
                                            <span class="curr">{$CS}</span>
                                        </span>
                                    </span>
                                    <span class="price-add">
                                        <span>
                                            (<span class="price" id="totalPriceAdd">bla-bla</span>
                                            <span class="curr-add">{$NextCs}</span>)
                                        </span>
                                    </span>
                                </span>
                            </span>
                        </div>
                        <!-- End. Price block-->
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>