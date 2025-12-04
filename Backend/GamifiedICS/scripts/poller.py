from pymodbus.client.sync import ModbusTcpClient
import threading, time, socket, struct

Explosion = False

def poll_PLC():
    global Explosion
    client = ModbusTcpClient('192.168.100.11', port=502) # 192.168.100.11 = IP of communications PLC
    while True:
        result = client.read_coils(80, 1) # coil 80 = %QX10.0 = address of 'Explosion' variable
        #result = client.read_holding_registers(20, 1) # holding register 20 = %QW20 = address of "Voltage" variable
        if not result.isError():
            Explosion = result.bits[0] # result.bits to read the value of the coil (%QX)
            #Explosion = result.registers[0] # result.registers to read the value of the holding register (%QW)
        time.sleep(1)

def tcp_server(host='0.0.0.0', port=5000):
    global Explosion
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((host, port))
    server.listen()

    while True:
        client_socket, client_address = server.accept() # create variables 'client_socket' and 'addr', setting them to the 2 values that server.accept() returns (returns a 2-value tuple, the first holding the client socket and the second holding the client IP and port)
        try:
            while True:
                if Explosion:
                	data = b'1' # you need the 'b' in front to convert the data to a byte (it is just the format that TCP transmits data in)
                else:
                	data = b'0'
                client_socket.sendall(data)
                time.sleep(1)
        except (ConnectionResetError, BrokenPipeError):
            client_socket.close()

if __name__ == '__main__':
    threading.Thread(target=poll_PLC, daemon=True).start()
    tcp_server(host='0.0.0.0', port=5000)
    
    
    
    
    # struct.pack() is a function that converts data of some type (defined in that first variable '>i') into an array of bits (the data format that transmissions over TCP use). In this case, '>i' just tells struct.pack() that the passed in value is an int ('i') of big-endian type ('>', where big-endian order is just the default order of reading bytes in networking).
