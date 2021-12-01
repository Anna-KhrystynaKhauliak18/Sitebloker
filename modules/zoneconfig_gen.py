def create_zonefile(domain, redirect_address):
    print(f"Started for {domain} to {redirect_address}")
    zone_file = open("fakedns.banlist.conf", "a+")
    zone_file.write(f'a {domain} {redirect_address}\n')

def wipe_zonefile(file):
    open(file, 'w').close()