<?php
class Cacher
{
  const CACHE_PATH = 'cache/cacher/';

  const CACHE_VERSION = '1';

  public static function fetch ($key = '', $callback)
  {
    $path = APPPATH . self::CACHE_PATH . self::CACHE_VERSION . $key . '.tmp';
    if (file_exists($path)) return unserialize(file_get_contents($path));

    try
    {
      $result = $callback(true);
    }
    catch (Exception $e)
    {
      var_dump($e);
      die;
    }

    if ($result === null) return $result;

    file_put_contents($path, serialize($result));
    return $result;
  }
}