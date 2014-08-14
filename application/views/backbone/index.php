<!DOCTYPE html>
<html>
  <head>
    <title>Paperboard</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/>
    <meta name="Author" content="Nicholas Valbusa, @squallstar on Twitter">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="application-name" content="Paperboard"/>
    <meta name="msapplication-TileColor" content="#333"/>
    <!--<meta name="msapplication-TileImage" content="<?php echo site_url('assets/img/apple-icon.png'); ?>"/>
    <link rel="apple-touch-icon" href="<?php echo site_url('assets/img/apple-icon.png'); ?>">-->
    <link rel="stylesheet" href="<?php echo site_url('assets/css/paperboard.css'); ?>" type="text/css" media="screen" />
    <script src="<?php echo site_url('assets/js/paperboard.js'); ?>?v=2"></script>
    <?php if (ENVIRONMENT == 'development') { ?><script src="http://localhost:35729/livereload.js"></script><?php } ?>
  </head>
  <body>
    <div id="overlay"></div>
    <div id="wrapper">
      <div id="rg-header"></div>
      <div id="rg-sidebar"></div>
      <div id="rg-content"></div>
    </div>
  </body>
  <script type="text/javascript">
    Paperboard.start({
      entrypoint:'<?php echo $entrypoint; ?>',
      route:'<?php echo $_SERVER["REQUEST_URI"]; ?>',
      data:<?php echo $data; ?>
    });
  </script>
</html>
