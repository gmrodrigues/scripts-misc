import mido

# Encontre o dispositivo MIDI conectado
port = mido.get_input_names()[0]
print("Conectado ao dispositivo MIDI:", port)

# Abra a conexão MIDI
with mido.open_input(port) as port:
    # Leia e imprima cada mensagem MIDI recebida
    for message in port:
        print(message)
