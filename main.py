# This Python file uses the following encoding: utf-8
import os
import configparser
from pathlib import Path
import sys
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

    someSignal = Signal()
    addListItem = Signal(str, arguments=['name'])

    servers = { "Quad9": "9.9.9.9",
                "Test": "127.0.0.1",
                "Cloudflare": "1.1.1.1",
                "Google Main": "8.8.8.8",
                "Google Backup": "8.8.4.4" }

    def __init__(self):
        super(Program, self).__init__()

    @Slot(str, result=str)
    def test(self):
        print("Test slot")
        self.populateServers()

    @Slot(str, result=str)
    def test2(self):
        print("Test2")
        self.populateServers()

    def populateServers(self):
        keys = self.servers.keys()
        for i in range(len(list(keys))):
            print(list(self.servers.keys())[i])
            self.addListItem.emit(str(list(keys)[i]))


if __name__ == "__main__":
    # sys.argv += ['--style', 'material']
    program = Program()
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.load(os.fspath(Path(__file__).resolve().parent / "main.qml"))
    getDNS()
    program.someSignal.connect(program.test)
    program.someSignal.emit()

    if not engine.rootObjects():
        sys.exit(-1)

    engine.rootContext().setContextProperty("program", program)
    engine.rootObjects()[0].button_signal.connect(program.test2, type=Qt.ConnectionType.AutoConnection)
    sys.exit(app.exec_())
