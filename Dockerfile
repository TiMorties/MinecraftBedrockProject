FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Обновляем систему и устанавливаем необходимые пакеты
RUN apt update && apt upgrade -y && \
    apt install -y wget unzip screen nodejs npm supervisor git

# Устанавливаем Minecraft Bedrock Server
WORKDIR /opt
RUN wget https://minecraft.azureedge.net/bin-linux/bedrock-server-1.21.60.01.zip -O bedrock_server.zip && \
    unzip bedrock_server.zip -d bedrock_server && \
    rm bedrock_server.zip

# Переходим в папку сервера
WORKDIR /opt/bedrock_server

# Открываем порт для Minecraft (UDP 19132)
EXPOSE 19132/udp

# Устанавливаем VoiceCraft
WORKDIR /opt
RUN git clone https://github.com/SineVector/VoiceCraft.git && \
    cd VoiceCraft && npm install

# Открываем порт для VoiceCraft (TCP 3000)
EXPOSE 3000

# Копируем конфигурационный файл supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Запускаем supervisor, который будет следить за обоими процессами
CMD ["/usr/bin/supervisord", "-n"]
