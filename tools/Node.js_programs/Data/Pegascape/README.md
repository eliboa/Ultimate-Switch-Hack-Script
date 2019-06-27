<p align="center">
  <a href=https://pegascape.sdsetup.com"><img src=https://i.imgur.com/H9ZLk33.png></a>
                                        </p>
                                        
<h1 align=center>https://pegascape.sdsetup.com/<br><i>for user-friendly details</i></h1>

## What is PegaScape?

PegaScape is a user-friendly public frontend for common PegaSwitch scripts including Nereba, Caffeine, HBL and more.

## What can PegaScape be used for?

With PegaScape, you can easily reboot from a stock Switch console running firmwares between 1.0.0-3.0.0 and 4.0.1-4.1.0 into full custom firmware and emuMMC. You can also install the Fake News entrypoint to make accessing PegaScape easier, and access the Homebrew Menu without running full custom firmware if you prefer.

**This means an easy-to-use entrypoint to fully featured CFW on 4.1.0 IPATCHED units.**

## Which scripts are supported on what firmware versions?

Fake News | Installer |	Reboot to RCM |	Nereba | HBL | Caffeine
------------|:-----------:|:---------------:|:--------:|:------:|----------
1.0.0 |	**✓** |	**✓** |	**✓** |	**✓** |	✗
2.0.0-3.0.0 |	✗ |	✗ |	✗ |	**✓** |	**✓**
4.0.0 |	✗ |	✗ |	✗ |	✗† | 	✗
4.0.1-4.1.0 |	✗ |	✗ |	✗ |	**✓** | 	**✓**
Other |	✗ |	✗ |	✗ |	✗ | 	✗

† nvcore offsets missing for 4.0.0

## Demo

[1.0.0 Switch booting into emuMMC 8.0.1](https://www.youtube.com/watch?v=hjZvmoRjA1U)

[4.1.0 Switch booting into Atmosphere CFW](https://www.youtube.com/watch?v=DBVjrjoZO8w)


## Usage

Follow https://switch.homebrew.guide for an easy to follow noob guide for going from stock 1.0.0 - 3.0.0 and 4.0.1 - 4.1.0 with PegaScape. Otherwise, if you want to jump in...

### Public DNS IP Addresses

We provide a public DNS IP for each common browser entrypoint present on the Switch:

**Webapplet (Fake News, 1.0 JP Puyo Puyo Tetris)**: 163.172.181.170

**Wifi Authentication Prompt**:	51.15.245.41

Note that these public DNS servers run the 90DNS configuration. This means that the connection test will pass (for the Webapplet server) and you can use homebrew with internet functionality, but you will not be able to connect to Nintendo services.

You can install Fake News with <a href="https://github.com/noahc3/fakenews-injector/releases/latest">Fake News Injector</a>

### Self Hosting

You can also self-host PegaScape yourself:

1. Install NodeJS and NPM.
2. Clone the repo.
3. Open cmd/terminal in the cloned directory.
4. Run `npm install`.
5. Run `[sudo] node start.js [--webapplet] [--ip <html_server_ip_override>] [--host <dns_server_ip_override] [--disable-dns]`.
    * `--webapplet`: To enable fake internet, allowing the Switch to pass the connection test and load things like Fake News.
    * `--ip <html_server_ip_override>` if the detected IP address for the HTML server is not preffered.
    * `--host <dns_server_ip_override` if the detected IP address for the DNS server is not preffered.
    * `--disable-dns` if you want to disable the internal DNS server and use something else (dnsmasq, bind, etc).
    * Root privileges are usually required on Linux to bind to port 80 and 53.
    
## Changes from PegaSwitch

* Logging is disabled by default (enable with "debug": true).
* Homepage is used to select exploits. Can be configured in `config.json`, and are automatically appended to `index.html` based on the connecting clients firmware version and the firmware requirements specified for each exploit.
* All device switching logic is removed/disabled.
* Websockets are never stored anywhere and are kicked off after the initial connection process completes.
* minmain.js is not run until an exploit is picked, rather than immediately when the page loads.
* You cannot interface with Switches through the CLI.
* Gadgetcache writes are disabled by default (enable with "debug": true).
* Endpoints not fit for a public server were removed.
* Some functionality which could be exploited on the server was removed or tweaked.
* Probably other stuff.

## Liability

Nobody is responsible if you lose your data, brick your Switch, get banned, drop your Switch into the toilet, have your Switch stolen by ninjas, etc, except yourself. By using PegaScape or any form of homebrew in any capacity you understand the risks involved with running unsigned code on your Switch.

## Credits

* ReSwitched, hexkyz and other contributors for PegaSwitch.
* Everyone who worked on smhax, nvhax, nspwn, etc.
* liuervehc for <a href="https://github.com/liuervehc/caffeine/">Caffeine</a>, bringing the first CFW to IPATCHED Switches, and dealing with my random support DMs.
* stuck_pixel for <a href="https://github.com/pixel-stuck/nereba/">Nereba</a> and <a href="https://github.com/pixel-stuck/reboot_to_rcm">reboot_to_rcm</a>.
* Switchbrew for <a href="https://github.com/switchbrew/nx-hbloader">nx-hbloader</a>.
* bernv3 for the sexy background art.
