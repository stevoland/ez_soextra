{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{def $style=''|soe_styles('block')
	$classes=''|soe_classes('block')}
{if and(is_unset($#use_inline_styles), is_unset($use_inline_styles))}
{if layout_line_start()|eq(true())}<div class="line yui3-g">{/if}
	<div class="unit{if is_set($size)} size{$size}{/if}{if and(is_set($last), $last|eq('true'))} lastUnit{/if} yui3-u {if $classes|trim|ne('')} {$classes|wash}{/if}"{if or(and(is_set($width), $width|trim|ne('')),and(is_set($height), $height|trim|ne(''))) } style="{if and(is_set($width), $width|trim|ne(''))}width:{$width|wash}{/if}{if and(is_set($height), $height|trim|ne(''))}height:{$height|wash}{/if}"{/if}><div class="content"{if $style|trim|ne('')} style="{$style}"{/if}>{$content}</div></div>
	{if $last|eq('true')}{if layout_line_end()|eq(true)}</div>{/if}{/if}
{else}
	{if layout_line_start()|eq(true())}<table border="0" cellpaddding="0" cellspacing="0" width="100%"><tr>{/if}
	{if is_unset($width)}
		{def $width=""}
		{if $last|ne('true')}
			{switch match=$size}
				{case match="1of2"}{set $width="50%"}{/case}
				{case match="1of3"}{set $width="33.333%"}{/case}
				{case match="2of3"}{set $width="66.666%"}{/case}
				{case match="1of4"}{set $width="25%"}{/case}
				{case match="3of4"}{set $width="75%"}{/case}
				{case match="1of5"}{set $width="20%"}{/case}
				{case match="2of5"}{set $width="40%"}{/case}
				{case match="3of5"}{set $width="60%"}{/case}
				{case match="4of5"}{set $width="80%"}{/case}
				{case match="1of6"}{set $width="16.656%"}{/case}
				{case match="5of6"}{set $width="83.33%"}{/case}
				{case match="1of8"}{set $width="12.5%"}{/case}
				{case match="3of8"}{set $width="37.5%"}{/case}
				{case match="5of8"}{set $width="62.5%"}{/case}
				{case match="7of8"}{set $width="87.5%"}{/case}
				{case}{/case}
			{/switch}
		{/if}
	{/if}
	<td width="{$width}" class="unit-table{if $last|eq('true')} lastUnit-table{/if}{if $classes|trim|ne('')} {$classes|wash}{/if}"{if $style|trim|ne('')} style="{$style}"{/if} valign="top">{$content}</td>
	{if $last|eq('true')}{if layout_line_end()|eq(true)}</tr></table>{/if}{/if}
{/if}