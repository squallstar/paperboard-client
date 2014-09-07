<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Fixtures extends CI_Controller
{
  public function v3($method='', $param1='', $param2='')
  {

    switch ($method)
    {
      case 'sign_in':
      case 'sign_up':
        echo file_get_contents(APPPATH . 'fixtures/sign_in.json');
        break;

      case 'user':
        if ($param1 == 'check_email')
        {
          echo "{}";
        }
        break;

      case 'collections':
        if ($param1 && $param2 == 'links')
        {
          echo file_get_contents(APPPATH . 'fixtures/links.json');
        }
        else {
          echo file_get_contents(APPPATH . 'fixtures/collections.json');
        }
        break;
    }
  }

  public function v4($method='', $param1='', $param2='')
  {

    switch ($method)
    {
      case 'collections':
        if ($param1 == 'recap')
        {
          echo file_get_contents(APPPATH . 'fixtures/recap.json');
        }
        break;
    }
  }
}