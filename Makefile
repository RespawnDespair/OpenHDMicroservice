
INC_DIR = ./inc
MAVLINK_DIR = ./lib/mavlink_generated/include/mavlink/v2.0 
SYSTEM_INCLUDE = /usr/local/include
SRC_DIR = ./src

LDFLAGS = -L/usr/local/lib -llifepo4wered -lboost_system -lboost_program_options


openhd_microservice: ina2xx.o microservice.o camera.o power.o main.o 
	g++ -g -pthread -o openhd_microservice ina2xx.o microservice.o camera.o power.o main.o $(LDFLAGS)

main.o: $(SRC_DIR)/main.cpp
	g++ -g -c -pthread -I$(SYSTEM_INCLUDE) -I$(MAVLINK_DIR) -I$(INC_DIR) $(SRC_DIR)/main.cpp

microservice.o: $(SRC_DIR)/microservice.cpp
	g++ -g -c -pthread -I$(SYSTEM_INCLUDE) -I$(MAVLINK_DIR) -I$(INC_DIR) $(SRC_DIR)/microservice.cpp

camera.o: $(SRC_DIR)/camera.cpp
	g++ -g -c -pthread -I$(SYSTEM_INCLUDE) -I$(MAVLINK_DIR) -I$(INC_DIR) $(SRC_DIR)/camera.cpp

power.o: $(SRC_DIR)/power.cpp
	g++ -g -c -pthread -I$(SYSTEM_INCLUDE) -I$(MAVLINK_DIR) -I$(INC_DIR) $(SRC_DIR)/power.cpp

ina2xx.o: $(SRC_DIR)/ina2xx.c
	gcc -g -c -pthread -I$(SYSTEM_INCLUDE) -I$(MAVLINK_DIR) -I$(INC_DIR) $(SRC_DIR)/ina2xx.c


clean:
	rm -f *.o openhd_microservice
