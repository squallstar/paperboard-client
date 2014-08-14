<?php
echo chdir('../');
echo shell_exec('git pull');
echo "----\r\nNPM: ";
echo shell_exec('npm install .');
echo "----\r\nGRUNT: ";
echo shell_exec('grunt build:production');