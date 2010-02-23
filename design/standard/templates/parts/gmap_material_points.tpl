var points{$seed} = [];
{def $infoWindowContents=''
     $desc=''}
{foreach $locations as $loc}
    {if $short_descriptive_attribute}
        {set-block variable=$desc}
            <div style="width:{$width|sub(100)}px;">{attribute_view_gui attribute=$loc.data_map.$short_descriptive_attribute}</div>
        {/set-block}
        {set $infoWindowContents = $desc|trim( '\n', '\r', ' ', '\x0B' )|wash( 'javascript' )|explode('\n')|implode( '' )|trim( ' ' ) }
    {/if}
    {*set $infoWindowContents = concat( $infoWindowContents, '<br /><a href="', $loc.url_alias|ezurl( no ), '">', "Read more..."|i18n("design/base"), '</a>' )*}

points{$seed}.push( [ new GLatLng( {$loc.data_map.$location_attribute.content.latitude}, {$loc.data_map.$location_attribute.content.longitude} ), '{$infoWindowContents}' ] );
{/foreach}

{* YAHOO.ezflgmapblock.GeoSearchState.setState( 'points{$seed}', points{$seed} ); *}