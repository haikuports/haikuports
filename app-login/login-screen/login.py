import sys
from PyQt5.QtWidgets import (QApplication, QWidget, QLabel, QLineEdit,
                             QPushButton, QVBoxLayout, QHBoxLayout, QMessageBox, QDesktopWidget, QAction)
from PyQt5.QtGui import QPixmap, QPalette, QBrush, QFont, QKeySequence
from PyQt5.QtCore import Qt

my_password = "root"

class LoginApp(QWidget):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Login")

        # Obține rezoluția ecranului
        screen = QDesktopWidget().screenGeometry()
        self.setGeometry(screen)  # Setează geometria ferestrei la cea a ecranului

        # Imagine de fundal scalată (VERIFICĂ CALEA!)
        pixmap = QPixmap("/boot/home/login/background.jpg")  # CALEA CORECTĂ AICI!
        if pixmap.isNull():
            print("Eroare: Imaginea nu a putut fi încărcată. Verifică calea.")
            sys.exit(1)

        scaled_pixmap = pixmap.scaled(screen.width(), screen.height())
        palette = QPalette()
        palette.setBrush(QPalette.Window, QBrush(scaled_pixmap))
        self.setPalette(palette)

        # Mesaj de bun venit cu dreptunghi și font mai mare
        self.welcome_label = QLabel("Wellcome to Haiku!", self)
        self.welcome_label.setAlignment(Qt.AlignCenter)

        welcome_width = int(screen.width() * 0.4)
        self.welcome_label.setFixedWidth(welcome_width)

        self.welcome_label.setStyleSheet("""
            background-color: white;
            color: black;
            padding: 10px;
            border-radius: 5px;
        """)

        font = QFont()
        font.setPointSize(18)
        self.welcome_label.setFont(font)

        # Casetă de parolă
        self.password_input = QLineEdit(self)
        self.password_input.setEchoMode(QLineEdit.Password)

        self.password_input.setStyleSheet("""
            background-color: white;
            color: black;
            padding: 10px;
            border-radius: 5px;
        """)

        password_width = int(screen.width() * 0.3)
        self.password_input.setFixedWidth(password_width)
        self.password_input.setFixedHeight(40)

        # Buton de autentificare
        login_button = QPushButton("Login", self)
        login_button.clicked.connect(self.check_password)

        login_width = int(screen.width() * 0.25)
        login_button.setFixedWidth(login_width)
        login_button.setFixedHeight(50)

        # Permite Enter pentru login (conectează la aceeași funcție)
        self.password_input.returnPressed.connect(self.check_password)

        # Layout vertical principal
        main_layout = QVBoxLayout()

        # Layout-uri orizontale pentru centrare individuală
        welcome_layout = QHBoxLayout()
        welcome_layout.addWidget(self.welcome_label)
        welcome_layout.setAlignment(Qt.AlignCenter)

        password_layout = QHBoxLayout()
        password_layout.addWidget(self.password_input)
        password_layout.setAlignment(Qt.AlignCenter)

        login_layout = QHBoxLayout()
        login_layout.addWidget(login_button)
        login_layout.setAlignment(Qt.AlignCenter)

        # Adăugăm layout-urile orizontale în layout-ul vertical principal
        main_layout.addStretch(1)  # Spațiu deasupra
        main_layout.addLayout(welcome_layout)
        main_layout.addStretch(1)  # Spațiu deasupra
        main_layout.addLayout(password_layout)
        main_layout.addStretch(1)  # Spațiu deasupra
        main_layout.addLayout(login_layout)
        main_layout.addStretch(1)  # Spațiu dedesubt

        self.setLayout(main_layout)

        # Activare fullscreen
        self.showFullScreen()

        # Shortcut pentru ieșire (Ctrl+Q) - mai fiabil (CORECTAT)
        exit_shortcut = QKeySequence(Qt.CTRL + Qt.Key_Q)
        exit_action = QAction(self)  # Creează un obiect QAction
        exit_action.setShortcut(exit_shortcut)  # Setează shortcut-ul pe acțiune
        exit_action.triggered.connect(self.close)  # Conectează acțiunea la self.close
        self.addAction(exit_action)  # Adaugă acțiunea la widget


    def check_password(self):
        password = self.password_input.text()
        if password == my_password:  # Înlocuiește cu parola reală
            self.close()
        else:
            QMessageBox.warning(self, "Error", "Wrong password.")

    def closeEvent(self, event):
        password = self.password_input.text()
        if password != my_password:
            event.ignore()  # Ignoră evenimentul de închidere


if __name__ == "__main__":
    app = QApplication(sys.argv)
    login_app = LoginApp()
    login_app.show()
    sys.exit(app.exec_())
