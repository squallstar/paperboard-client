<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Fixtures extends CI_Controller
{
  public function json($code, $string = "{}")
  {
    $this->output->set_content_type('application/json')
         ->set_status_header(200)
         ->set_output($string);
  }

  public function v3($method='', $param1='', $param2='')
  {

    switch ($method)
    {
      case 'sign_in':
      case 'sign_up':
        $this->json(200, file_get_contents(APPPATH . 'fixtures/sign_in.json'));
        break;

      case 'user':
        if ($param1 == 'check_email')
        {
          $this->json(200);
        }
        break;

      case 'collections':
        if ($param1 && $param2 == 'links')
        {
          $this->json(200, file_get_contents(APPPATH . 'fixtures/links.json'));
        }
        else {
          $this->json(200, file_get_contents(APPPATH . 'fixtures/collections.json'));
        }
        break;

      case 'directory':
        if ($param1 == 'tags')
        {
          $this->json(200, file_get_contents(APPPATH . 'fixtures/tags.json'));
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
          $this->json(200, file_get_contents(APPPATH . 'fixtures/recap.json'));
        }
        break;
    }
  }
}