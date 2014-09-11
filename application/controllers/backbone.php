<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Backbone extends CI_Controller
{
  public function index()
  {
    header("Cache-Control: no-cache");

    $entrypoint = rtrim($this->config->item('api_domain'), '/') . '/';
    $auth_token = $this->input->cookie('_probe_tkn');

    if ($this->input->get('access_token'))
    {
      $auth_token = $this->input->get('access_token');
      $this->input->set_cookie([
        'name' => '_probe_tkn',
        'value' => $auth_token,
        'expire' => 604800
      ]);
    }

    $data = 'false';

    if ($auth_token)
    {
      $url = $entrypoint . 'v4/collections/recap?auth_token=' . $auth_token;

      try {
        $data = @file_get_contents($url);
      } catch (Exception $e) {
        return show_error('We are having some technical issues right now. Please try later');
      }
    }

    if (!$data) $data = 'false';

    $this->load->view('backbone/index', array(
      'data' => $data,
      'entrypoint' => $entrypoint
    ));
  }
}