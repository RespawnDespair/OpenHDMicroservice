
INC_DIR = ./inc
MAVLINK_DIR = ./lib/mavlink_generated/include/mavlink/v2.0 
SRC_DIR = ./src

ifeq ($(PREFIX),)
	PREFIX := /usr/local
endif

SYSTEM_INCLUDE = $(PREFIX)/include
LDFLAGS = -L$(PREFIX)/lib -llifepo4wered -lboost_system -lboost_program_options


openhd_microservice: bcm2835.o ina2xx.o microservice.o gpio.o camera.o power.o status.o main.o 
	g++ -g -pthread -o openhd_microservice bcm2835.o ina2xx.o microservice.o gpio.o camera.o power.o status.o main.o $(LDFLAGS)

main.o: $(SRC_DIR)/main.cpp
	g++ -std=c++11 -g -c -pthread -I$(SYSTEM_INCLUDE) -I$(MAVLINK_DIR) -I$(INC_DIR) $(SRC_DIR)/main.cpp

microservice.o: $(SRC_DIR)/microservice.cpp
	g++ -std=c++11 -g -c -pthread -I$(SYSTEM_INCLUDE) -I$(MAVLINK_DIR) -I$(INC_DIR) $(SRC_DIR)/microservice.cpp

camera.o: $(SRC_DIR)/camera.cpp
	g++ -std=c++11 -g -c -pthread -I$(SYSTEM_INCLUDE) -I$(MAVLINK_DIR) -I$(INC_DIR) $(SRC_DIR)/camera.cpp

power.o: $(SRC_DIR)/power.cpp
	g++ -std=c++11 -g -c -pthread -I$(SYSTEM_INCLUDE) -I$(MAVLINK_DIR) -I$(INC_DIR) $(SRC_DIR)/power.cpp

gpio.o: $(SRC_DIR)/gpio.cpp
	g++ -std=c++11 -g -c -pthread -I$(SYSTEM_INCLUDE) -I$(MAVLINK_DIR) -I$(INC_DIR) $(SRC_DIR)/gpio.cpp

status.o: $(SRC_DIR)/status.cpp
	g++ -std=c++11 -g -c -pthread -I$(SYSTEM_INCLUDE) -I$(MAVLINK_DIR) -I$(INC_DIR) $(SRC_DIR)/status.cpp

ina2xx.o: $(SRC_DIR)/ina2xx.c
	gcc -g -c -pthread -I$(SYSTEM_INCLUDE) -I$(MAVLINK_DIR) -I$(INC_DIR) $(SRC_DIR)/ina2xx.c

bcm2835.o: $(SRC_DIR)/bcm2835.c
	gcc -g -c -pthread -I$(SYSTEM_INCLUDE) -I$(MAVLINK_DIR) -I$(INC_DIR) $(SRC_DIR)/bcm2835.c


clean:
	rm -f *.o openhd_microservice

.PHONY: install
install: openhd_microservice
	install -d $(PREFIX)/bin/
	install -m 755 openhd_microservice $(PREFIX)/bin/
	install -m 644 openhd_microservice@.service /etc/systemd/system/
	install -d /etc/openhd
	install -m 644 openhd_microservice.conf /etc/openhd/

.PHONY: enable
enable: install
	systemctl enable openhd_microservice@power
	systemctl start openhd_microservice@power

	systemctl enable openhd_microservice@gpio
	systemctl start openhd_microservice@gpio

	systemctl enable openhd_microservice@camera
	systemctl start openhd_microservice@camera

.PHONY: uninstall
uninstall:
	rm -f $(PREFIX)/bin/openhd_microservice
