<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Backbone extends CI_Controller
{
  public function index()
  {
    $entrypoint = $this->config->item('api_domain');
    $auth_token = $this->input->cookie('_probe_tkn');

    if ($auth_token)
    {
      $url = $entrypoint . 'v3/user?auth_token=' . $auth_token;

      $data = file_get_contents($url);

      if (isset(json_decode($data)->id))
      {
        $user = $data;
      }
    }
    else
    {
      $user = 'false';
    }

    $this->load->view('backbone/index', array(
      'user' => $user,
      'entrypoint' => $entrypoint
    ));
  }
}