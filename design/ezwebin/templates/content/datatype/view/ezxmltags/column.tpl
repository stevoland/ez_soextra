{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{def $style=''|soe_styles('column')
	 $classes=''|soe_classes('column')}
{column_count_inc(1)}{column_width_inc($width|int)}
<div class="col{if $classes|trim|ne('')} {$classification|wash}{/if}"{if $style|trim|ne('')} style="{$style}"{/if}>{$content}</div>