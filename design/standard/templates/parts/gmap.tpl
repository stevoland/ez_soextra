{if is_set($show_popups_on_page)|not}
{def $show_popups_on_page=false()}
{/if}
{if is_set($map_id)|not}
{def $map_id='map'}
{/if}
{if is_set($map_type)|not}
{def $map_type = 'G_NORMAL_MAP'}
{/if}
{if is_set($popup_view)|not}
{def $popup_view = 'line'}
{/if}
{if is_set($location_attribute)|not}
{def $location_attribute = 'location'}
{/if}
{if is_set( $short_descriptive_attribute )|not }
{def $short_descriptive_attribute='description'}
{/if}

{default $width=400
	     $height=400
		 $css_class=''}
{def $size=array($width, $height)}

{def $seed = rand( 0, 100000 )}
{set $map_id=concat( $map_id, $seed )}

{if is_unset($in_oe)}
{run-once}
<script src="http://maps.google.com/maps?file=api&amp;v=2.x&amp;key={ezini('SiteSettings','GMapsKey')}" type="text/javascript"></script>
{/run-once}

<script type="text/javascript">

{include uri="design:parts/gmap_material_points.tpl" 
         seed=$seed 
         locations=$locations 
         short_descriptive_attribute=$short_descriptive_attribute 
         location_attribute=$location_attribute}
</script>
<div id="{$map_id}" class="content-view-embed-content {$css_class}" style="{if is_unset($in_oe)}width:{$width}px; height:{$height}px; {/if}{$inner_style}">

{/if}
{def $markers=''
	 $i=1}
{foreach $locations as $loc}
	{set $markers=concat($markers, $loc.data_map[$location_attribute].content.latitude, ',', $loc.data_map[$location_attribute].content.longitude, ',red', $i, '|')
		 $i=$i|inc(1)}
{/foreach}
<img class="soextra_resizable" width="{$size.0}" height="{$size.1}"  src="http://maps.google.com/staticmap?center={$locations.0.data_map.$location_attribute.content.latitude},{$locations.0.data_map.$location_attribute.content.longitude}&{if is_set($object_parameters.zoom)}zoom={$object_parameters.zoom}&{/if}size={$size.0}x{$size.1}&markers={$markers}&key={ezini('SiteSettings','GMapsKey')}&sensor=false" />

{if is_unset($in_oe)}
</div>

{ezscript(array('ezjsc::yui3'), 'text/javascript', '')}
<script type="text/javascript">
    var mapid{$seed} = '{$map_id}';    
    var map{$seed} = null;
    var geocoder = null;
    //var gmapExistingOnload = null;
    var marker = null;

    {literal}
    
    function createMarker( lat, lng, info, bounds, icon)
    {
      var point = new GLatLng(lat, lng);
      var marker = new GMarker( point, icon );
      GEvent.addListener(marker, "click", function() {
        marker.openInfoWindowHtml(info);
      });
      if (bounds)
      {
          bounds.extend(point);
      }
      return marker;      
    }


    var load{/literal}{$seed}{literal} = function(ev){
        if (GBrowserIsCompatible()) {
          map{/literal}{$seed}{literal} = new GMap2(document.getElementById(mapid{/literal}{$seed}{literal}));
          map{/literal}{$seed}{literal}.addControl(new GMapTypeControl());
          map{/literal}{$seed}{literal}.addControl(new GLargeMapControl());
          map{/literal}{$seed}{literal}.setCenter(new GLatLng(0,0), 0);
          var bounds = new GLatLngBounds();
    {/literal}
    
	{def $location_data = null}
	var marker,
		firstMarker,
		firstInfo;
	{foreach $locations as $index=>$location}
	    {if is_set($location.name)}
	    {set $location_data = $location.data_map[$location_attribute].content}
	    {else}
	    {set $location_data = $location}
	    {/if}
          var popupwindow_{$index}=unescape( points{$seed}[{$index}][1] );
		  marker = createMarker({$location_data.latitude},{$location_data.longitude},popupwindow_{$index}, bounds);
		  if ( !firstMarker )
		  {ldelim}
			firstMarker = marker;
			firstInfo = popupwindow_{$index};
		  {rdelim}
          map{$seed}.addOverlay(marker);
    {/foreach}
    
          map{$seed}.setMapType({$map_type});
          {if is_set($center)}
          var center = new GLatLng({$center[0]},{$center[1]});
          {else}
          var center = bounds.getCenter();
          {/if}
          {if is_set($object_parameters.zoom)}
          var zoom = {$object_parameters.zoom};
          {else}
          var zoom = map{$seed}.getBoundsZoomLevel(bounds);
          {/if}
		  if ( firstMarker )
			firstMarker.openInfoWindowHtml(firstInfo);
          map{$seed}.setCenter(center,zoom);
    {literal}
       
        }
    };
    {/literal}
    
    //Y().u( load{$seed} );
    YUI(YUI3_config).use('event-base', function(Y){ldelim}
      Y.on('domready', function(){ldelim}
        load{$seed}();
      {rdelim});
    {rdelim});
</script>
{/if}