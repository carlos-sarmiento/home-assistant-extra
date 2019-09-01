FROM homeassistant/home-assistant:latest

RUN pip3 install pymysql && pip3 install opencv-python
