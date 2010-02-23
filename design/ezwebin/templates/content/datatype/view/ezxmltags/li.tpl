{* DO NOT EDIT THIS FILE! Use an override template instead.
*}{def $style=''}{*
*}{default $class_styles=ezini( 'sOExtraSettings', 'ClassStyles', 'soextra.ini',,true() )}{*
*}{if and( or(is_set($#use_inline_styles), is_set($use_inline_styles)), $classification|trim, is_set($class_styles[$classification]) )}{*
	*}{set $style=concat($style, $class_styles[$classification]|wash) }{*
*}{/if}{*
*}{if and( is_set( $fontclass ), $fontclass|trim )}{*
	*}{if and( or(is_set($#use_inline_styles), is_set($use_inline_styles)), is_set($class_styles[$fontclass]) ) }{*
		*}{set $style=concat($style, $class_styles[$fontclass]|wash) }{*
	*}{else}{*
		*}{set $classification = concat( $classification, ' ', $fontclass ) }{*
	*}{/if}{*
*}{/if}{*
*}{if and(is_set($forecolor), $forecolor|trim)}{set $style=concat($style, 'color:', $forecolor|wash, '; ') }{/if}{*
*}{if and(is_set($backcolor), $backcolor|trim)}{set $style=concat($style, 'background-color:', $backcolor|wash,'; ') }{/if}{*
*}{if and(is_set($fontsize), $fontsize|trim)}{if and( and(is_unset($#use_inline_styles), is_unset($use_inline_styles)), $fontsize|contains('px'), $fontsize|int|ge(10), $fontsize|int|le(26) )}{set $classification=concat( $classification, ' font-', $fontsize|wash )}{else}{set $style=concat($style, 'font-size:', $fontsize|wash, '; ') }{/if}{/if}
<li{section show=ne($classification|trim,'')} class="{$classification|wash}"{/section}{if $style|ne('')} style="{$style}"{/if}>{$content}</li>
