# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys
import dns.resolver

#import settings_rc

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Slot, Qt


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

    @Slot(str, result=str)
    def test(self):
        print("Test")


if __name__ == "__main__":
    #sys.argv += ['--style', 'material']
    program = Program()
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.load(os.fspath(Path(__file__).resolve().parent / "main.qml"))
    getDNS()
    if not engine.rootObjects():
        sys.exit(-1)
    
    engine.rootObjects()[0].button_signal.connect(program.test, type=Qt.ConnectionType.AutoConnection)
    sys.exit(app.exec_())

