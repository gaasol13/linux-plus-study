# Unit 6 - Deploying Software

## Scenario 
Junior Linux admin tasked with auditing and hardening an ubuntu server before postgreSQL production deployment 

## Environment 
- OS: Ubuntu Server 24.04 (NOBLE)
- Platform: VirtualBox
- Shell: Bash

## Phases Completed 

### Phase 1 - system inventory
Captured the full package baseline using dpkg -l, apt-mark showmanual/showauto, systemctl, lsblk, and df. Saving the outpu to system_inventory_ph1.txt

### Phase 2 - PostgreSQL Repository and Install
Added official PGDG apt repository. Imported GPG key. Installed PostgresSQL 16

### Phase 3 - Repository audit and misconfig
Deliberately introduced suite misconfiguration (sudo-pgdg instead of noble-pgdg). Diagnosed error from apt update output

### Phase 4 - Broken dependency recovery
Simulated broken dpkg state on cowsay. Practiced recovery sequence:
dpkg --audit -> dpkg --configure -a -> apt --fix-broken install

### Phase 5 - Sandboxed software
Audite installed Snaps. Added flathub remote. Installed Flatpak app. 
Compared storage locations: snap vd /var/lib/flatpak


## Key Commands Reference
- dpkg -l → list all installed packages
- dpkg -S /path → find which package owns a file
- dpkg -L pkgname → list all files a package installed
- apt-mark showmanual → explicitly installed packages
- apt-mark showauto → auto-installed dependencies
- dpkg --audit → check for broken packages
- snap list → list installed snaps
- flatpak remote-add → add a flatpak repository
- resolvectl dns enp0s8 8.8.8.8 → set DNS on interface

