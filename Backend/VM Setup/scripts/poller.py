from flask import Flask, jsonify
from pymodbus.client.sync import ModbusTcpClient
import threading, time

app = Flask(__name__)
value = False

def poll_PLC():
    global value
    client = ModbusTcpClient('192.168.100.11', port=502) # 192.168.100.11 = IP of communications PLC
    while True:
        result = client.read_coils(80, 1) # coil 80 = %QX10.0 = address of 'Explosion' variable
        #result = client.read_holding_registers(20, 1) # holding register 20 = %QW20 = address of "Voltage" variable
        if not result.isError():
            value = result.bits[0] # result.bits to read the value of the coil (%QX)
            #value = result.registers[0] # result.registers to read the value of the holding register (%QW)
        time.sleep(1)

@app.route('/plc/state')
def get_state():
    return jsonify({'value': value})

if __name__ == '__main__':
    threading.Thread(target=poll_PLC, daemon=True).start()
    app.run(host='0.0.0.0', port=5000)
