<?php

class sOELayoutOperator
{
    function __construct()
    {
		$this->Operators = array( 'layout_line_start',
                                    'layout_line_end',
                                    'column_start',
                                    'column_count_inc',
                                    'column_width_inc',
                                    'column_count_get',
                                    'column_width_get');
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
        return array( 'layout_line_start' => array(),
                      'layout_line_end' => array(),
                      'column_count_inc' => array('inc' => array( 'type' => 'integer',
                                                                  'required' => false,
                                                                  'default' => 1 )),
                      'column_width_inc' => array('inc' => array( 'type' => 'integer',
                                                                  'required' => false,
                                                                  'default' => 1 ))
					);
    }

    function modify( &$tpl, &$operatorName, &$operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters )
    {
        switch ( $operatorName )
        {
            case 'layout_line_start':
            {
				if ( self::$isFirst )
				{
					self::$isFirst = false;
					$ret = true;
				}
				else
				{
					$ret = false;
				}
            } break;
            case 'layout_line_end':
            {
				$ret = ( self::$isFirst ) ? false : true;
				self::$isFirst = true;
            } break;
            case 'column_start':
            {
                self::$columnCount = 0;
                self::$columnWidth = 0;
                $ret = '';
            } break;
            case 'column_count_inc':
            {
                self::$columnCount += $namedParameters['inc'];
                $ret = '';
            } break;
            case 'column_width_inc':
            {
                self::$columnWidth += $namedParameters['inc'];
                $ret = '';
            } break;
            case 'column_count_get':
            {
                $ret = self::$columnCount;
            } break;
            case 'column_width_get':
            {
                $ret = self::$columnWidth;
            } break;
        }

        $operatorValue = $ret;

    }

    /// \privatesection
	
	static $isFirst = true;
    
    static $columnCount = 0;
    static $columnWidth = 0;

    /// \return The class variable 'Operators' which contains an array of available operators names.
    var $Operators;

    /// \privatesection
    /// \return The class variable 'Debug' to false.
    var $Debug;
    
}

?>
