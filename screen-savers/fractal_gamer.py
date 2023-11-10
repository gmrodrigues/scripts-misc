import pygame
import numpy as np
from noise import snoise2

# Define as dimensões da janela
WIDTH = 800
HEIGHT = 600

# Define as constantes para a geração do terreno
OCTAVES = 5
PERSISTENCE = 0.5
LACUNARITY = 2.0
SCALE = 200.0

# Gera o mapa de ruído usando o Simplex Noise
def generate_noise_map(width, height, scale, octaves, persistence, lacunarity):
    noise_map = np.zeros((height, width))
    for y in range(height):
        for x in range(width):
            amplitude = 1.0
            frequency = 1.0
            noise_height = 0.0
            for o in range(octaves):
                sample_x = x / scale * frequency
                sample_y = y / scale * frequency
                perlin_value = snoise2(sample_x, sample_y, 1)
                noise_height += perlin_value * amplitude
                amplitude *= persistence
                frequency *= lacunarity
            noise_map[y][x] = noise_height
    return noise_map

# Cria o mapa de ruído
noise_map = generate_noise_map(WIDTH, HEIGHT, SCALE, OCTAVES, PERSISTENCE, LACUNARITY)

# Inicializa o Pygame
pygame.init()

# Cria a janela e define o título
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Fractal World")

# Define as cores para o terreno
COLORS = [(255, 255, 255), (0, 0, 255), (0, 255, 0), (255, 255, 0), (128, 128, 128)]

# Desenha o terreno na tela
def draw_terrain(screen, noise_map, colors):
    for y in range(HEIGHT):
        for x in range(WIDTH):
            index = int(noise_map[y][x] * len(colors))
            color = colors[index]
            pygame.draw.rect(screen, color, (x, y, 1, 1))

# Define a posição inicial do jogador
player_x = WIDTH / 2
player_y = HEIGHT / 2

# Define a velocidade do jogador
player_speed = 5

# Define a função para movimentar o jogador
def move_player(dx, dy):
    global player_x, player_y
    new_x = player_x + dx
    new_y = player_y + dy
    if new_x >= 0 and new_x < WIDTH and new_y >= 0 and new_y < HEIGHT:
        player_x = new_x
        player_y = new_y

# Loop principal do jogo
running = True
while running:

    # Processa os eventos
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_UP:
                move_player(0, -player_speed)
            elif event.key == pygame.K_DOWN:
                move_player(0, player_speed)
            elif event.key == pygame.K_LEFT:
                move_player(-player_speed, 0)
            elif event.key == pygame.K_RIGHT:
                move_player(player_speed, 0)

    # Desenha o terreno e o jogador na tela
    screen.fill((0, 0, 0))
    draw_terrain(screen, noise_map, COLORS)
    pygame.draw.circle(screen, (255, 0, 0), (int(player_x), int(player_y)), 5)
    # Atualiza a tela
    pygame.display.flip()

