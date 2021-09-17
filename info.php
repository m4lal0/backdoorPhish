<?php
include "get_ip.php";
$os = $_POST["os_name"];
$os_ver = $_POST["os_ver"];
$browser_name = $_POST["browser_name"];
$browesr_version = $_POST["browser_ver"];
$device_name = $_POST['device_name'];
$device_type = $_POST['device_type'];
$device_vendor = $_POST['device_vendor'];
$cpu_architec = $_POST["cpu_architec"];
$cpu_cores = $_POST["cpu_cores"];
$device_res = $_POST["device_resolution"];
$time_zone = $_POST["time_zone"];
$user_lang = $_POST["user_lang"];
$user_agent = $_POST["user_agent"];
$device_memory = $_POST["device_memory"];


$data['info'] = array(
    'OS-Name' => $os,
    'OS-Version' => $os_ver,
    'Browser-Name' => $browser_name,
    'Browser-Version' => $browesr_version,
    'Device-Name' => $device_name,
    'Device-Type' => $device_type,
    'Device-Vendor' => $device_vendor,
    'CPU-Architecture' => $cpu_architec,
    'CPU-Cores' => $cpu_cores,
    'Device-Resolution' => $device_res,
    'Time-Zone' => $time_zone,
    'User-Language' => $user_lang,
    'User-Agent' => $user_agent,
    'Device-Memory' => $device_memory,
);
$jdata = json_encode($data);

$file = 'logs/info.json';
$f = fopen($file, 'w');
fwrite($f, $jdata);
fclose($f);
?>