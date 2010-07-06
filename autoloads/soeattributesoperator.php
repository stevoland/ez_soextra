<?php

class sOEAttributesOperator
{
    function __construct()
    {
		$this->Operators = array( 'soe_styles', 'soe_classes' );
        $this->Debug = false;
    }

    function operatorList()
    {
        return $this->Operators;
    }

    function namedParameterPerOperator()
    {
        return true;
    }

    function namedParameterList()
    {
        return array( 'soe_styles' => array('tagName' => array( 'type' => 'string',
                                                                'required' => true )),
                      'soe_classes' => array('tagName' => array( 'type' => 'string',
                                                                 'required' => true ))
					);
    }

    function modify( &$tpl, &$operatorName, &$operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters )
    {
        $ini = eZINI::instance( 'content.ini' );
        $customAttributes = ( $ini->hasVariable( $namedParameters['tagName'], 'CustomAttributes' ) ) ?
            $ini->variable( $namedParameters['tagName'], 'CustomAttributes' ) : array();
        
        $ini = eZINI::instance( 'soextra.ini' );
        $classStyles = $ini->variable( 'sOExtraSettings', 'ClassStyles' );
        
        $attributes = array();
        foreach ( $tpl->Variables as $nameSpace => $variables )
        {
            foreach ( $variables as $name => $val )
            {
                if ( is_string($val) ) {
                    $val = trim($val);
                    if ( !empty($val) ) {
                        $attributes[$name] = $val;
                    }
                }
            }
        }
        
        $useInlineStyles = ( isset($attributes['use_inline_styles']) && $attributes['use_inline_styles'] );
        
        $tagName = $namedParameters['tagName'];
                
        switch ( $operatorName )
        {
            case 'soe_styles':
            {
                if ( in_array('forecolor', $customAttributes) && isset($attributes['forecolor']) ) {
                    $operatorValue .= 'color:' . $attributes['forecolor'] . ';';
                }
                if ( in_array('backcolor', $customAttributes) && isset($attributes['backcolor']) ) {
                    $operatorValue .= 'background-color:' . $attributes['backcolor'] . ';';
                }
                if ( in_array('margin', $customAttributes) && isset($attributes['margin']) ) {
                    $operatorValue .= 'margin:' . $attributes['margin'] . ';';
                }
                if ( in_array('padding', $customAttributes) && isset($attributes['padding']) ) {
                    $operatorValue .= 'padding:' . $attributes['padding'] . ';';
                }
                if ( $tagName == 'htmlcode_inner' ) {
                    if ( isset($attributes['attr_width']) ) {
                        $operatorValue .= 'width:' . $attributes['attr_width'] . 'px;';
                    }
                    if ( isset($attributes['attr_height']) ) {
                        $operatorValue .= 'height:' . $attributes['attr_height'] . 'px;';
                    }
                } else {
                    if ( in_array('width', $customAttributes) && isset($attributes['width']) ) {
                        $operatorValue .= 'width:' . $attributes['width'] . ';';
                    }
                    if ( in_array('height', $customAttributes) && isset($attributes['height']) ) {
                        $operatorValue .= 'height:' . $attributes['height'] . ';';
                    }
                }
                if ( in_array('lineheight', $customAttributes) && isset($attributes['lineheight']) ) {
                    $operatorValue .= 'line-height:' . $attributes['lineheight'] . ';';
                }
                if ( in_array('border', $customAttributes) && isset($attributes['border']) ) {
                    $operatorValue .= 'border:' .$attributes['border'] . ';';
                } else {
                    if (in_array('border_color', $customAttributes) && isset($attributes['border_color']) ) {
                        $operatorValue .= 'border-color:' . $attributes['border_color'] . ';';
                    }
                    if (in_array('border_style', $customAttributes) && isset($attributes['border_style']) ) {
                        $operatorValue .= 'border-style:' . $attributes['border_style'] . ';';
                    }
                    if (in_array('border_size', $customAttributes) && isset($attributes['border_size']) ) {
                        $operatorValue .= 'border-width:' . $attributes['border_size'] . ';';
                    }
                }
                if ( isset($attributes['align']) ) {
                    $operatorValue .= 'text-align:' . $attributes['align'] . ';';
                }
                if ( $useInlineStyles ) {
                    if ( in_array('fontclass', $customAttributes) && isset($attributes['fontclass']) ) {
                        if ( isset( $classStyles[$attributes['fontclass']] ) ) {
                            $operatorValue .= $classStyles[$attributes['fontclass']];
                        }
                    }
                    if ( isset($attributes['classification']) && isset( $classStyles[$attributes['classification']] ) ) {
                        $operatorValue .= $classStyles[$attributes['classification']];
                    }
                    if ( in_array('cssclass', $customAttributes) && isset($attributes['cssclass']) ) {
                        if ( isset( $classStyles[$attributes['cssclass']] ) ) {
                            $operatorValue .= $classStyles[$attributes['cssclass']];
                        }
                    }
                    if ( $tagName == 'embed-inline' && isset($attributes['object_parameters']) ) {
                        $align = $attributes['object_parameters']['align'];
                        if ( $align == 'right' ) {
                            $operatorValue .= 'clear:right;float:right;margin-left:6px;';
                        } else if ( $align == 'left' ) {
                            $operatorValue .= 'clear:left;float:left;margin-right:6px;';
                        }
                    }
                }
                if ( in_array('fontsize', $customAttributes) && isset($attributes['fontsize']) ) {
                    $fontsize = (int)$attributes['fontsize'];
                    if ( ( strpos($attributes['fontsize'], 'px' !== false) && $fontsize < 10 && $fontsize > 26 ) || $useInlineStyles ) {
                        $operatorValue .= 'font-size:' . $attributes['fontsize'] . ';';
                    }
                }
                if ( $tagName == 'htmlcode_inner' && !isset($attributes['display_inline']) &&
                    ( isset($attributes['align']) || $useInlineStyles ) ) {
                    $align = $attributes['align'];
                    if ( $align == 'left' || ( !$align && $useInlineStyles ) ) {
                        $operatorValue .= 'margin-left:0;margin-right:auto;';
                    } elseif ( $align == 'left') {
                        $operatorValue .='margin-left:auto;margin-right:0;';
                    } elseif ( $align == 'center') {
                        $operatorValue .='margin-left:auto;margin-right:auto;';
                    }
                }
            } break;
            case 'soe_classes':
            {
                if ( isset($attributes['classification']) ) {
                    $operatorValue .= $attributes['classification'] . ' ';
                }
                if ( isset($attributes['align']) ) {
                    $prefix = ( $tagName == 'htmlcode' ) ? 'object-' : 'text-';
                    $operatorValue .= $prefix . $attributes['align'] . ' ';
                }
                if ( in_array('fontclass', $customAttributes) && isset($attributes['fontclass']) ) {
                    $operatorValue .= $attributes['fontclass'] . ' ';
                }
                if ( in_array('fontsize', $customAttributes) && isset($attributes['fontsize']) ) {
                    $operatorValue .= 'font-' . $attributes['fontsize'] . ' ';
                }
                if ( $tagName == 'embed-inline' && isset($attributes['object_parameters']) ) {
                    $align = $attributes['object_parameters']['align'];
                    if ( $align ) {
                        $operatorValue .= 'object-' . $align . '';
                    }
                }
                if ( $tagName == 'htmlcode' ) {
                    $operatorValue .= ( isset($attributes['display_inline']) ) ? 'htmlcode-inline ' : 'htmlcode ';
                    if ( !isset($attributes['in_oe']) && isset($attributes['align']) ) {
                        $operatorValue .= 'object-' . $attributes['align'];
                    }
                }
            } break;
        }

    }

    /// \privatesection
    
    /// \return The class variable 'Operators' which contains an array of available operators names.
    var $Operators;

    /// \privatesection
    /// \return The class variable 'Debug' to false.
    var $Debug;
    
    
}

?>
