<select name="{$custom_attribute}" id="{$custom_attribute_id}_source"{if $custom_attribute_disabled} disabled="disabled"{/if} title="{$custom_attribute_title|wash}" class="{$custom_attribute_classes|implode(' ')}">
{if ezini_hasvariable( $tag_name, 'AvailableClasses', 'content.ini' )}
{def $descriptions=cond( ezini_hasvariable($tag_name, 'ClassDescription', 'content.ini',,true()  ), ezini($tag_name, 'ClassDescription', 'content.ini',,true() ), hash() ) }
{if and( ezini_hasvariable( $custom_attribute_settings, 'AllowEmpty', 'ezoe_attributes.ini' ), ezini( $custom_attribute_settings, 'AllowEmpty', 'ezoe_attributes.ini' )|eq(true) )}
    <option value=""></option>
{/if}
{foreach ezini( $tag_name, 'AvailableClasses', 'content.ini' ) as $class}
    <option value="{if $class|ne('-0-')}{$class|wash}{/if}"{if $class|eq( $custom_attribute_default )} selected="selected"{/if}>{if is_set($descriptions[$class])}{$descriptions[$class]|wash}{else}{$class|wash}{/if}</option>
{/foreach}
{/if}
</select>