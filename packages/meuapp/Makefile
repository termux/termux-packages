# Makefile para criar e empacotar o pacote Termux

# Variáveis
PACKAGE_NAME = meuapp
VERSION = 1.0
ARCHITECTURE = all
MAINTAINER = Você <seuemail@exemplo.com>
DESCRIPTION = "Meu pacote Termux"
DEBIAN_DIR = meu_pacote/DEBIAN
DATA_DIR = meu_pacote/data/data/com.termux/files/usr
BIN_DIR = $(DATA_DIR)/bin
OUTPUT_DIR = $(PACKAGE_NAME).deb

# Criar estrutura de diretórios
create_directories:
	mkdir -p $(DEBIAN_DIR)
	mkdir -p $(BIN_DIR)

# Criar o arquivo de controle do pacote
create_control:
	echo "Package: $(PACKAGE_NAME)" > $(DEBIAN_DIR)/control
	echo "Version: $(VERSION)" >> $(DEBIAN_DIR)/control
	echo "Architecture: $(ARCHITECTURE)" >> $(DEBIAN_DIR)/control
	echo "Maintainer: $(MAINTAINER)" >> $(DEBIAN_DIR)/control
	echo "Description: $(DESCRIPTION)" >> $(DEBIAN_DIR)/control

# Criar o script do aplicativo
create_app_script:
	echo -e '#!/bin/bash\necho "Meu pacote Termux está funcionando!"' > $(BIN_DIR)/$(PACKAGE_NAME)
	chmod +x $(BIN_DIR)/$(PACKAGE_NAME)

# Empacotar os arquivos
create_package:
	tar czf $(DEBIAN_DIR)/control.tar.gz -C $(DEBIAN_DIR) .
	tar czf $(OUTPUT_DIR)/data.tar.gz -C $(DATA_DIR) .
	echo "2.0" > $(DEBIAN_DIR)/debian-binary
	ar r $(PACKAGE_NAME).deb $(DEBIAN_DIR)/debian-binary $(DEBIAN_DIR)/control.tar.gz $(OUTPUT_DIR)/data.tar.gz

# Instalar o pacote (opcional)
install_package:
	dpkg -i $(PACKAGE_NAME).deb || echo "Erro na instalação, tentando outra abordagem..."
	cp $(BIN_DIR)/$(PACKAGE_NAME) ~/.local/bin/
	chmod +x ~/.local/bin/$(PACKAGE_NAME)

# Limpeza (opcional)
clean:
	rm -rf meu_pacote
	rm $(PACKAGE_NAME).deb

# Execução
all: create_directories create_control create_app_script create_package install_package
