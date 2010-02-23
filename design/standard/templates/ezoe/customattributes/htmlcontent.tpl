<textarea id="{$custom_attribute_id}_textarea" {if $custom_attribute_disabled} disabled="disabled"{/if} class="{$custom_attribute_classes|implode(' ')}" title="{$custom_attribute_title|wash}" onchange="sOExtra_htmlcontentUpdated('{$custom_attribute_id}', '{$custom_tag}');" rows="4" cols="40" /></textarea>
<input type="hidden" name="{$custom_attribute}" id="{$custom_attribute_id}_source" value="" />

<script type="text/javascript">
<!--
{literal}
if ( !window.sOExtra_htmlcontentUpdated )
{
	sOExtra_htmlcontentUpdated = function(id, tagName)
	{
		var textarea = document.getElementById( id + '_textarea' );
		var source = document.getElementById( id + '_source' );
		source.value = escape(textarea.value);
		
		var match = textarea.value.match(/width=["|']([0-9]+)["|']/);
		if ( !!match )
		{
			var attr_width = document.getElementById(tagName + '_attr_width_source');
			if ( !!attr_width )
			{
				attr_width.value = match[1];
			}
		}
		match = textarea.value.match(/height=["|']([0-9]+)["|']/);
		if ( !!match )
		{
			var attr_height = document.getElementById(tagName + '_attr_height_source');
			if ( !!attr_height )
			{
				attr_height.value = match[1];
			}
		}
	}
}
{/literal}
eZOEPopupUtils.settings.customAttributeInitHandler['{$custom_attribute_id}_source'] = {literal} function( el, value )
{
	var textarea = document.getElementById( el.id.replace('_source', '_textarea') );
	textarea.value = unescape(value);
    el.value = value;
};{/literal}

eZOEPopupUtils.settings.customAttributeSaveHandler['{$custom_attribute_id}_source'] = {literal} function( el, value )
{
    return el.value;
};{/literal}

//-->
</script>