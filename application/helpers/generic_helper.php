<?php

/**
 * CDN URL helper
 *
 * @access  public
 * @param string
 * @return  string
 */
if ( ! function_exists('cdn_url'))
{
  function cdn_url($uri = '')
  {
    $CI =& get_instance();
    return $CI->config->cdn_url($uri);
  }
}