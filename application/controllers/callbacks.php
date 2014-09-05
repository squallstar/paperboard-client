<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Callbacks extends CI_Controller
{
  public function connected_account($type)
  {
    $this->load->view('callbacks/vent', ['type' => $type]);
  }
}