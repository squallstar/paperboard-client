<!DOCTYPE html>
<html>
  <head>
    <title><?php echo $meta['title'] ? $meta['title'] . ' - ' : ''; ?>Paperboard</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="application-name" content="Paperboard"/>
    <meta name="msapplication-TileColor" content="#333"/>
    <meta property="og:site_name" content="Paperboard" />
    <?php if ($meta['image']) {
    ?><meta property="og:type" content="article" />
    <meta property="article:published_time" content="<?php echo date('Y-m-d H:i:s', $meta['pubdate']); ?>" />
    <meta property="og:title" content="<?php echo $meta['title']; ?>">
    <meta property="og:image" content="<?php echo $meta['image']; ?>">
    <?php } ?>
    <meta name="description" content="<?php echo $meta['description']; ?>">
    <meta name="author" content="<?php echo $meta['author'] ? $meta['author'] . ' on Paperboard' : 'Nicholas Valbusa, @squallstar on Twitter'; ?>">
    <meta name="msapplication-TileImage" content="<?php echo cdn_url('assets/img/touch-logo.png'); ?>"/>
    <link rel="apple-touch-icon" href="<?php echo cdn_url('assets/img/touch-logo.png'); ?>">
    <link rel="stylesheet" href="<?php echo cdn_url('assets/css/paperboard.css?v=' . BUILD_NUMBER); ?>" type="text/css" media="screen" />
    <script src="<?php echo cdn_url('assets/js/paperboard.js?v=' . BUILD_NUMBER); ?>"></script>
    <?php if (ENVIRONMENT == 'development') { ?><script src="http://localhost:35729/livereload.js"></script><?php } ?>
  </head>
  <body>
    <div id="font-loader">
      <span class="font-proxima-nova">Please wait while we load the environment.</span>
      <span class="font-proxima-nova-condensed"><a href="/">Refresh</a>.</span>
    </div>

    <div id="overlay"></div>
    <div id="wrapper">
      <div id="rg-overlay"></div>
      <div id="rg-header"></div>
      <div id="rg-sidebar"></div>
      <div id="rg-content"></div>
    </div>

    <script type="text/javascript">
    $(window).load(function() {
      Paperboard.start({
        entrypoint:'<?php echo $entrypoint; ?>',
        route:'<?php echo $_SERVER["REQUEST_URI"]; ?>',
        data:<?php echo $data; ?>,
        intent: <?php echo $intent; ?>
      });
    });
    </script>
  </body>
</html>
