# This Python file uses the following encoding: utf-8
import os, signal, sys, subprocess
from pathlib import Path
import dns.resolver

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Slot, Signal, Qt


def getDNS():
    print("Called function getDNS")
    getter = dns.resolver.Resolver()

    try:
        engine.rootObjects()[0].setProperty('primaryServer', getter.nameservers[0])
    except IndexError:
        print('Error at detecting primary DNS. It can\'t be empty even in the hell!')

    try:
        engine.rootObjects()[0].setProperty('secondaryServer', getter.nameservers[1])
    except IndexError:
        print('Error at detecting secondary DNS. It can be empty, though it\'s unrecommended.')


class Program(QObject):

    server = "0.0.0.0"

    server_status = False   # False - вимкнено, True - увімкнено 
    server_pid = 0

    startSignal = Signal()
    someSignal = Signal()
    addListItem = Signal(str, arguments=['name'])

    servers = { "Quad9": "9.9.9.9",
                "Test": "127.0.0.1",
                "Cloudflare": "1.1.1.1",
                "Google Main": "8.8.8.8",
                "Google Backup": "8.8.4.4" }

    def __init__(self):
        super(Program, self).__init__()
        self.generate_zones_from_config('banlist.ini')
        getDNS()

    @Slot(str, result=str)
    def startServer(self):
        from modules import zoneconfig_gen as gen
        # self.addSite("google.com")

        if self.server_status:
            # print(result.pid)
            # subprocess.Popen.kill(result)
            print(os.kill(self.server_pid, signal.SIGTERM)) 
            self.server_status = False
        else:
            self.startSignal.emit()
            result = subprocess.Popen(['python','fakedns.py', '-c', 'fakedns.banlist.conf'], shell=True)
            print(result)
            self.server_status = True
            self.server_pid = result.pid
            print(self.server_pid)



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


    @Slot(str, result=str)
    def test2(self):
        print("Test2")
        self.populateServers()

    @Slot(str)
    def populateServers(self):
        keys = self.servers.keys()
        for i in range(len(list(keys))):
            print(list(self.servers.keys())[i])
            self.addListItem.emit(str(list(keys)[i]))

    @Slot(str)
    def setDNS(self, server):
        serverIP = self.servers.get(server)
        print(serverIP)
        self.server = serverIP
        print(self.server)


if __name__ == "__main__":
    # sys.argv += ['--style', 'material']
    program = Program()
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.load(os.fspath(Path(__file__).resolve().parent / "main.qml"))
    getDNS()
    

    if not engine.rootObjects():
        sys.exit(-1)
    print(engine.rootObjects()[0])
    engine.rootContext().setContextProperty("program", program)
    engine.rootObjects()[0].button_signal.connect(program.startServer, type=Qt.ConnectionType.AutoConnection)
    engine.rootObjects()[0].init_signal.connect(program.populateServers, type=Qt.ConnectionType.AutoConnection)
    engine.rootObjects()[0].setServer.connect(program.setDNS, type=Qt.ConnectionType.AutoConnection)
    sys.exit(app.exec_())
