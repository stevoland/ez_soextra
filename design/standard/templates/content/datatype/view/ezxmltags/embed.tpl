{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{def $style=''|soe_styles('embed')
	 $classes=''|soe_classes('embed')}
<div class="embed-tag{if and( is_unset($in_oe), $object_parameters.align )} object-{$object_parameters.align}{/if}{if ne($classes|trim,'')} {$classes|wash}{/if}"{if is_set($object_parameters.id)} id="{$object_parameters.id}"{/if}>
{content_view_gui view=$view link_parameters=$link_parameters object_parameters=$object_parameters content_object=$object classification=$classification in_oe=cond(is_set($in_oe),true()) inner_style=$style}
</div>