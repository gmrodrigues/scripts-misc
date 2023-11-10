#include <iostream>
#include <unistd.h>
#include "RtMidi.h"

int main()
{
    std::cout << "Drum MIDI Test" << std::endl;
    RtMidiIn midiin;
    std::cout << "Versão da biblioteca RtMidi: " << midiin.getVersion() << std::endl;

    // Verifique se há dispositivos MIDI disponíveis
    int portCount = midiin.getPortCount();
    if (portCount == 0) {
        std::cout << "Nenhum dispositivo MIDI disponível." << std::endl;
        return 1;
    }

    // Liste todos os dispositivos MIDI disponíveis
    std::cout << "Dispositivos MIDI disponíveis:" << std::endl;
    for (int i = 0; i < portCount; i++) {
        std::cout << " - " << midiin.getPortName(i) << std::endl;
    }

    // Abra a primeira porta MIDI
    midiin.openPort(0);

    std::cout << "Conectado ao dispositivo MIDI: " << midiin.getPortName(0) << std::endl;

    // Receba e imprima as mensagens MIDI
    while (true) {
        std::cout << "Aguardando mensagens MIDI..." << std::endl;
        std::vector<unsigned char> message;
        double timestamp = midiin.getMessage(&message);
        
        if (message.size() > 0) {
            for (unsigned int i = 0; i < message.size(); i++) {
                std::cout << (int)message[i] << ".";
            }
            std::cout << std::endl;
        }
        else {
            // Aguarda um segundo antes de tentar receber a próxima mensagem MIDI
            usleep(1000000);
        }
    }

    return 0;
}
