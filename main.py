# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys
import dns.resolver


from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine

def getDNS():
    console.log("Called function getDNS")
    my_resolver = dns.resolver.Resolver()
    console.log(my_resolver.nameservers)

if __name__ == "__main__":
    sys.argv += ['--style', 'imagine']
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.load(os.fspath(Path(__file__).resolve().parent / "main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())

def getDNS():
    my_resolver = dns.resolver.Resolver()
    print(my_resolver.nameservers[0])
    engine.rootObjects()[0].setProperty('primaryServer', my_resolver.nameservers[0])
