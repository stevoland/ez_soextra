<?php

/*
 * Generates all i18n strings for the TinyMCE editor
 * and transforms them to the TinyMCE format for
 * translations.
 */

require_once( 'kernel/common/i18n.php' );

class soextraServerFunctions extends ezjscServerFunctions
{
    /**
     * i18n
     * Provides all i18n strings for use by TinyMCE and other javascript dialogs.
     * 
     * @static
     * @param array $args
     * @param string $fileExtension
     * @return string returns json string with translation data
    */
    public static function i18n( $args, $fileExtension )
    {
        $lang = '-en';
        $locale = eZLocale::instance();
        if ( $args && $args[0] )
            $lang = $args[0];

        $i18nArray =  array( $lang => array(
            'soextra' => array(
                
            ),
        ));
        $i18nString = json_encode( $i18nArray );

        return 'tinyMCE.addI18n( ' . $i18nString . ' );';
    }

    /**
     * getCacheTime
     * Expiry time for code generators registirated on this class.
     * Needs to be increased to current time when changes are done to returned translations.  
     * 
     * @static
     * @param string $functionName
    */
    public static function getCacheTime( $functionName )
    {
        static $mtime = null;
        if ( $mtime === null )
        {
            $mtime = filemtime( __FILE__ );
        }
        return $mtime;
    }
}

?>
