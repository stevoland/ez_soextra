{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{def $style=''|soe_styles('quote')
	$classes=''|soe_classes('quote')}
<blockquote{if $classes|trim|ne('')} class="{$classes|wash}"{/if}{if $style|trim|ne('')} style="{$style}"{/if}><span class="hide">"</span>{$content}<span class="hide">"</span></blockquote>
