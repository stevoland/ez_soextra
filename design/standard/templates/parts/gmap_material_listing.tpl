<div id="{$map_id}" style="width: {$size[0]}px; height: {$size[1]}px"></div>
{if $locations}
<div class="locations" {if $show_popups_on_page|not}style="display: none"{/if}>
    {def $location_node=null}
    <div class="attribute-long">
    <ul>
    {foreach $locations as $key => $location}
        {set $location_node = $location.object.main_node}
        <li>
        <div class="location" id="location_{$location.contentobject_id}">    
            {* <a onclick="map{$seed}.panTo( points{$seed}[{$key}][0] );map{$seed}.setCenter( points{$seed}[{$key}][0], 13 );map{$seed}.openInfoWindowHtml( points{$seed}[{$key}][0], unescape( points{$seed}[{$key}][1] ) );">{$location.name}</a> *}
            <a onclick="map{$seed}.panTo( gs( 'points{$seed}' )[{$key}][0] );map{$seed}.setCenter( gs( 'points{$seed}' )[{$key}][0], 13 );map{$seed}.openInfoWindowHtml( gs( 'points{$seed}' )[{$key}][0], unescape( gs( 'points{$seed}' )[{$key}][1] ) );">{$location.name}</a>
            
        </div>
        </li>
    {/foreach}
    </ul> 
    </div> 
</div>
{/if}