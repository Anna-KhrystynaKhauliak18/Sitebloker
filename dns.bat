echo off
set interface=%1
set resolver=%2
netsh interface ipv4 set dns %interface% static %resolver%