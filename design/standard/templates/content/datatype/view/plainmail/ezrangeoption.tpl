{*<label>{$attribute.content.name}</label><div class="labelbreak"></div>

<select name="eZOption[{$attribute.id}]">
{section name=Option loop=$attribute.content.option_list sequence=array(bglight,bgdark)}
<option value="{$Option:item.id}">{$Option:item.value}</option>

{/section}
</select>*}