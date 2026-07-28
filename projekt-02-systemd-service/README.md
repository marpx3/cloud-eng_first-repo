Anlage eines eigenen Dienstes (UNIT)

1. sh script anlegen (uhrzeit.sh) -> per sudo da im system
    sudo vim /usr/local/bin/uhrzeit.sh
    sudo chmod +x /usr/local/bin/uhrzeit.sh

2. UNIT datei anlegen (uhrzeit.service)
    sudo vim /etc/systemd/system/uhrzeit.service

3. Einlesen und starten
    sudo systemctl daemon-reload
    sudo systemctl start uhrzeit
    systemctl status uhrzeit

4. Prozess beenden und prüfen ob er selbst neu startet
    sudo kill -9 19787
    systemctl status uhrzeit

5. Autostart beim Boot aktivieren
    sudo systemctl enable uhrzeit

6. Deaktivieren und löschen
    sudo systemctl disable --now uhrzeit
    sudo rm /etc/systemd/system/uhrzeit.service /usr/local/bin/uhrzeit.sh /var/log/uhrzeit.log
    sudo systemctl daemon-reload