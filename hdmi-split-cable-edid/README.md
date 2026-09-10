# HDMI Split Cable - Fix EDID

## O que é EDID?

**EDID** (Extended Display Identification Data) é um bloco de dados (256 bytes) que o monitor envia para a placa de vídeo informando quais resoluções, taxas de refresh e outras capacidades ele suporta. Sem ele, o driver de vídeo assume o valor mais seguro: **640×480**.

## O problema

Splitters HDMI **passivos** (baratos) frequentemente não propagam o EDID corretamente. O resultado é que o sistema operacional só enxerga a resolução 640×480, pois não consegue "ouvir" o que os monitores informam.

Neste sistema (Arch Linux + systemd-boot + UKI), a solução é:

1. Extrair o EDID quando os monitores estiverem funcionando
2. Salvá-lo em `/lib/firmware/edid/monitor.bin`
3. Forçar o kernel a usar esse EDID via parâmetro de boot `drm.edid_firmware`
4. Incluir o EDID na initramfs/UKI (via `FILES` no `mkinitcpio.conf`)
5. Reconstruir a UKI com `mkinitcpio`

## Uso

O script tem duas fontes possíveis para o EDID:

- **`edid.bin`** no mesmo diretório do script (se existir, é usado como fonte)
- **Conector HDMI** (`/sys/class/drm/card1-HDMI-A-1/edid`) — usado se `edid.bin` não existir

Isso permite rodar o script mesmo sem o monitor conectado, desde que um `edid.bin` já tenha sido capturado anteriormente.

```bash
# 1. Conecte o monitor direto na saída HDMI (sem splitter) para capturar o EDID real
# 2. Execute o script:
sudo ./fix-edid.sh
# 3. Reinicie:
sudo reboot
```

Após o reboot, o EDID salvo será carregado pelo kernel **sempre**, independente da ordem de conexão dos cabos.

## Reverter

Se precisar desfazer:

```bash
# Remover o parâmetro do cmdline
sudo sed -i 's/ drm.edid_firmware=HDMI-A-1:edid\/monitor.bin//' /etc/kernel/cmdline
# Remover o EDID do FILES do mkinitcpio.conf
sudo sed -i 's|FILES=(/lib/firmware/edid/monitor.bin)|FILES=()|' /etc/mkinitcpio.conf
# Reconstruir a UKI
sudo mkinitcpio -p linux
# Remover os arquivos EDID (opcional)
sudo rm /lib/firmware/edid/monitor.bin
rm ./edid.bin
# Reiniciar
sudo reboot
```

## Informações do sistema

| Componente | Detalhe |
|------------|---------|
| Distribuição | Arch Linux |
| Bootloader | systemd-boot |
| Kernel | UKI (Unified Kernel Image) em `/boot/EFI/Linux/arch-linux.efi` |
| GPU | AMD Lucienne (Ryzen 5000 integrado) |
| Cmdline | `/etc/kernel/cmdline` |
| Initramfs | mkinitcpio |
