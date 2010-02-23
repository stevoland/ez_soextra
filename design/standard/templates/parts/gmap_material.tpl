<script type="text/javascript">

{include uri="design:parts/gmap_material_points.tpl" 
         seed=$seed 
         locations=$locations 
         short_descriptive_attribute=$short_descriptive_attribute 
         location_attribute=$location_attribute}

</script>

{include uri="design:parts/gmap_material_listing.tpl"
 		map_id=$map_id
 		size=$size
 		locations=$locations
 		show_popups_on_page=$show_popups_on_page
   		seed=$seed}