<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Backbone extends CI_Controller
{
  public function index()
  {
    header("Cache-Control: no-cache");

    $entrypoint = $this->config->item('api_domain');
    $auth_token = $this->input->cookie('_probe_tkn');

    $data = 'false';

    if ($auth_token)
    {
      $url = $entrypoint . 'v4/collections/recap?auth_token=' . $auth_token;

      try {
        $data = @file_get_contents($url);
      } catch (Exception $e) {

      }

    }

    $this->load->view('backbone/index', array(
      'data' => $data,
      'entrypoint' => $entrypoint
    ));
  }
}