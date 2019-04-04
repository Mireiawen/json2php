<?php
use Zend\Code\Generator\ValueGenerator;
require_once('vendor/autoload.php');

$smarty = new Smarty();
$tpl = $smarty -> createTemplate('page.tpl.html');

$json = '';
$error = '';

if (isset($_POST['json']))
{
	$json = $_POST['json'];
}

try
{
	$data = json_decode($json, true, 512, JSON_THROW_ON_ERROR);
	$generator = new ValueGenerator($data, ValueGenerator::TYPE_ARRAY_SHORT);
	$generator->setIndentation('  ');
	$php = $generator->generate();
}
catch (\JsonException $e)
{
	$error = $smarty -> createTemplate('error.tpl.html');
	$error -> assign('message', $e -> getMessage());
	$error = $error -> fetch();
}

$tpl -> assign('error', $error);
$tpl -> assign('json', $json);
$tpl -> assign('php', $php);

$tpl -> display();
