def create_zonefile(domain, ttl):
    print("Started")
    path = "server/Zones/"
    zone_name = path + domain + '.zone'
    zone_file = open(zone_name, "w+")
    zone_file.write('{\n\t\"$origin\": "' + domain + '",\n\t"$ttl": ' + str(ttl) + ',\n\n')
    zone_file.write('\t\"soa\": {\n\t\t\"mname\": \"ns1.' + domain + '\",\n\t\t')
    zone_file.write('\"rname\": \"admin.' + domain + '\",\n\t\t')
    zone_file.write('\"serial\": \"{time}",\n\t\t\"retry\": \"600",\n\t\t\"expire\": \"604800",\n\t\t')
    zone_file.write('\"minimum\": \"86400"\n\t},\n\n\t"ns": [\n\t\t{"host": "ns1.' + domain + '"}\n\t],\n\n')
    zone_file.write('\t"a": [\n\t\t{"name": "@",\n\t\t  "ttl": 400,\n\t\t  "value": "127.0.0.1"\n\t\t}\n\t]\n}')

