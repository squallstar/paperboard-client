<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Backbone extends CI_Controller
{
  public function index()
  {
    $entrypoint = $this->config->item('api_domain');
    $auth_token = $this->input->cookie('_probe_tkn');

    if ($auth_token)
    {
      $url = $entrypoint . 'v4/collections/recap?auth_token=' . $auth_token;
      $data = file_get_contents($url);
    }
    else
    {
      $data = 'false';
    }

    $this->load->view('backbone/index', array(
      'data' => $data,
      'entrypoint' => $entrypoint
    ));
  }
}