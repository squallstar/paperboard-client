<!DOCTYPE html>
<html>
  <head>
    <title><?php echo $meta['title'] ? $meta['title'] . ' - ' : ''; ?>Paperboard</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/>
    <meta name="author" content="Nicholas Valbusa, @squallstar on Twitter">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="application-name" content="Paperboard"/>
    <meta name="msapplication-TileColor" content="#333"/>

    <meta name="description" content="<?php echo $meta['description']; ?>">
    <?php if ($meta['image']) {
    ?><meta property="og:title" content="<?php echo $meta['title']; ?>">
    <meta property="og:image" content="<?php echo $meta['image']; ?>">
    <?php } ?>

    <!--<meta name="msapplication-TileImage" content="<?php echo site_url('assets/img/apple-icon.png'); ?>"/>
    <link rel="apple-touch-icon" href="<?php echo site_url('assets/img/apple-icon.png'); ?>">-->

    <link rel="stylesheet" href="<?php echo cdn_url('assets/css/paperboard.' . BUILD_NUMBER . '.css'); ?>" type="text/css" media="screen" />
    <script src="<?php echo cdn_url('assets/js/paperboard.' . BUILD_NUMBER . '.js'); ?>"></script>
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
