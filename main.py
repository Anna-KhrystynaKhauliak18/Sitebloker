# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys
import dns.resolver

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine


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


if __name__ == "__main__":
    sys.argv += ['--style', 'imagine']
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.load(os.fspath(Path(__file__).resolve().parent / "main.qml"))
    getDNS()
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
