# This Python file uses the following encoding: utf-8
import os, sys, re, signal, psutil
from pathlib import Path
import dns.resolver

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Slot, Signal, Qt

@Slot(int)
def getDNS():
    # print("Called function getDNS")
    getter = dns.resolver.Resolver()

    dnss = getter.nameservers

    for i in dnss:
        if re.search('^(192.168)', i):
            dnss.remove(i)

    for i in dnss:
        if re.search('^(172)', i):
            dnss.remove(i)

    for i in dnss:
        if re.search('^(10)', i):
            dnss.remove(i)

    try:
        engine.rootObjects()[0].setProperty('primaryServer', dnss[0])
    except IndexError:
        engine.rootObjects()[0].setProperty('primaryServer', '0.0.0.0')
        # print('Error at detecting primary DNS. It can\'t be empty even in the hell!')

    try:
        engine.rootObjects()[0].setProperty('secondaryServer', dnss[1])
    except IndexError:
        engine.rootObjects()[0].setProperty('secondaryServer', '0.0.0.0')
        # print('Error at detecting secondary DNS. It can be empty, though it\'s unrecommended.')


class Program(QObject):

    server = "0.0.0.0"

    server_status = False   # False - вимкнено, True - увімкнено 
    server_pid = 0
    server_thread =''

    system_nic = ''

    startSignal = Signal()
    someSignal = Signal()
    addServersItem = Signal(str, arguments=['name'])
    addInterfacesItem = Signal(str, arguments=['name'])

    servers = { "Quad9": "9.9.9.9",
                "Test": "127.0.0.1",
                "Cloudflare": "1.1.1.1",
                "Google Main": "8.8.8.8",
                "Google Backup": "8.8.4.4" }


    def __init__(self):
        super(Program, self).__init__()
        self.generate_zones_from_config('banlist.ini')


    @Slot(str, result=str)
    def startServer(self):
        from modules import zoneconfig_gen as gen
        # self.addSite("google.com")

        if self.server_status == False:
            os.system(f'Powershell Start dns.bat -ArgumentList "{self.system_nic}","127.0.0.1" -Verb Runas')
            self.startSignal.emit()
            process = os.system(f'start cmd /k fakedns.bat {self.server}') # subprocess.Popen(['python','fakedns.py', '-c', 'fakedns.banlist.conf', '--dns', self.server], shell=True)
            self.server_status = True
            
        elif self.server_status == True:
            for proc in psutil.process_iter(['pid', 'name', 'username']):
                if 'cmd.exe' in proc.name():
                    print(str(proc.info) + '\n')
                    children = psutil.Process(proc.pid).children()
                    for child in children:
                        print(child.pid)
                        os.kill(child.pid, signal.SIGINT)
            os.system(f'Powershell Start dns.bat -ArgumentList "{self.system_nic}","9.9.9.9" -Verb Runas')
            self.server_status = False
        
        


    def generate_zones_from_config(self, configfile):
        import configparser
        from modules import zoneconfig_gen as gen
        conf = configparser.ConfigParser()
        conf.read(configfile)
        banned_dict = dict(conf.items('BANLIST'))
        banned = banned_dict.values()
        gen.wipe_zonefile('fakedns.banlist.conf')
        for domain in banned:
            gen.create_zonefile(domain, "0.0.0.0")


    def addSite(self, domain):
        import configparser, random
        conf = configparser.ConfigParser(strict=False)

        conf.read('banlist.ini')
        
        conf.set('BANLIST', f'domain{random.randint(1000,5000)}', domain)
        with open('banlist.ini', 'r+') as configfile:
            conf.write(configfile)


    # @Slot(str, result=str)
    # def test2(self):
        print("Test2")
        self.populateServers()


    @Slot(str)
    def populateServers(self):
        keys = self.servers.keys()
        for i in keys:
            print(i)
            self.addServersItem.emit(i)
        self.populateInterfaces()


    @Slot(str, result=str)
    def populateInterfaces(self):
        import psutil
        addrs = psutil.net_if_addrs()
        nics = addrs.keys()
        print(nics)
        for i in nics:
            self.addInterfacesItem.emit(i)


    @Slot(str)
    def setDNS(self, server):
        serverIP = self.servers.get(server)
        print(serverIP)
        self.server = serverIP
        print(self.server)


    @Slot(str)
    def setNIC(self, nic):
        print(nic)
        self.system_nic = nic 
        print(self.system_nic)


if __name__ == "__main__":
    # sys.argv += ['--style', 'material']
    program = Program()
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.load(os.fspath(Path(__file__).resolve().parent / "main.qml"))
    

    if not engine.rootObjects():
        sys.exit(-1)
    print(engine.rootObjects()[0])
    engine.rootContext().setContextProperty("program", program)
    engine.rootObjects()[0].dns_signal.connect(getDNS, type=Qt.ConnectionType.AutoConnection)
    engine.rootObjects()[0].button_signal.connect(program.startServer, type=Qt.ConnectionType.AutoConnection)
    engine.rootObjects()[0].init_signal.connect(program.populateServers, type=Qt.ConnectionType.AutoConnection)
    engine.rootObjects()[0].setServer.connect(program.setDNS, type=Qt.ConnectionType.AutoConnection)
    engine.rootObjects()[0].setInterface.connect(program.setNIC, type=Qt.ConnectionType.AutoConnection)
    sys.exit(app.exec_())
