<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Backbone extends CI_Controller
{
  public function index()
  {
    header("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
    header("Expires: Sat, 26 Jul 1997 05:00:00 GMT"); // Date in the past

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

    $meta = [
      'title' => '',
      'description' => '',
      'image' => ''
    ];

    $data = 'false';
    $intent = ['type' => null, 'data' => null];

    $uri = $this->router->uri->uri_string;

    if (preg_match("/^article\/([A-z0-9\-])+/", $uri, $matches))
    {
      $article_id = str_replace('article/', '', $matches[0]);

      try {
        $d = @file_get_contents($entrypoint . 'v3/articles/' . $article_id);
        $d = json_decode($d, true);

        if (isset($d['name']))
        {
          $intent = [
            'type' => 'article',
            'data' => $d
          ];

          $meta['title'] = substr($d['name'], 0, 100);
          $meta['description'] = substr($d['description'], 0, 200);

          if (isset($d['lead_image']['url_archived_medium']))
          {
            $meta['image'] = $d['lead_image']['url_archived_medium'];
          }
        }
      } catch (Exception $e) {

      }
    }

    if ($auth_token)
    {
      $url = $entrypoint . 'v4/collections/recap?auth_token=' . $auth_token;

      try {
        $data = @file_get_contents($url);
      } catch (Exception $e) {
        return show_error('We are having some technical issues right now. Please try later');
      }
    }

    if (strpos($data, '{') !== 0) $data = 'false';

    $this->load->view('backbone/index', array(
      'meta' => $meta,
      'intent' => json_encode($intent),
      'data' => $data,
      'entrypoint' => $entrypoint
    ));
  }
}