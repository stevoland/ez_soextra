<?php

$eZTemplateOperatorArray = array();
$eZTemplateOperatorArray[] = array( 'script' => 'extension/_soextra/autoloads/soelayoutoperator.php',
                                    'class' => 'sOELayoutOperator',
                                    'operator_names' => array( 'layout_line_start',
                        							'layout_line_end',
                        							'column_start',
                        							'column_count_inc',
                        							'column_width_inc',
                        							'column_count_get',
                        							'column_width_get') );
$eZTemplateOperatorArray[] = array( 'script' => 'extension/_soextra/autoloads/ezxmloutputoperator.php',
                                    'class' => 'eZXMLOutputOperator',
                                    'operator_names' => array( 'ezxmloutput') );
$eZTemplateOperatorArray[] = array( 'script' => 'extension/_soextra/autoloads/sjsencodingoperator.php',
                                    'class' => 'sJSEncodingOperator',
                                    'operator_names' => array( 'js_encode_uri', 'js_decode_uri', 'js_encode_uri_component', 'js_decode_uri_component', 'js_escape', 'js_unescape' ) );
$eZTemplateOperatorArray[] = array( 'script' => 'extension/_soextra/autoloads/sregexoperator.php',
                                    'class' => 'sRegexOperator',
                                    'operator_names' => array( 'preg_replace') );
$eZTemplateOperatorArray[] = array( 'script' => 'extension/_soextra/autoloads/soeattributesoperator.php',
                                    'class' => 'sOEAttributesOperator',
                                    'operator_names' => array( 'soe_styles', 'soe_classes' ) );
?>
