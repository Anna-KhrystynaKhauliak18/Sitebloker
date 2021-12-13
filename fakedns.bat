echo off
set defaultserv=%1
python fakedns.py -c fakedns.banlist.conf --dns %defaultserv%