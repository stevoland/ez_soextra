{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{def $style=''|soe_styles('ul')
     $classes=''|soe_classes('ul')}
<ul{section show=ne($classes|trim,'')} class="{$classes|wash}"{/section}{if $style|trim|ne('')} style="{$style}"{/if}>
{$content}
</ul>
