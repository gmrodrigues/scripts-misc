import pygame
from OpenGL.GL import *
import pymesh

pygame.init()

# Carregue a imagem
image = pygame.image.load('image.png')
image_width, image_height = image.get_size()

# Crie uma janela Pygame
window_size = (640, 480)
pygame.display.set_mode(window_size, pygame.DOUBLEBUF|pygame.OPENGL)

# Defina a projeção OpenGL
glViewport(0, 0, window_size[0], window_size[1])
glMatrixMode(GL_PROJECTION)
glLoadIdentity()
glOrtho(0, image_width, image_height, 0, -1, 1)
glMatrixMode(GL_MODELVIEW)
glLoadIdentity()

# Desenhe a imagem na janela
glClear(GL_COLOR_BUFFER_BIT)
glEnable(GL_TEXTURE_2D)
glBindTexture(GL_TEXTURE_2D, glGenTextures(1))
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image_width, image_height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pygame.image.tostring(image, 'RGBA'))
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
glBegin(GL_QUADS)
glTexCoord2f(0, 0); glVertex2f(0, 0)
glTexCoord2f(1, 0); glVertex2f(image_width, 0)
glTexCoord2f(1, 1); glVertex2f(image_width, image_height)
glTexCoord2f(0, 1); glVertex2f(0, image_height)
glEnd()
glDisable(GL_TEXTURE_2D)

# Trace o contorno da imagem
glColor3f(1, 1, 1)
glBegin(GL_LINE_STRIP)
for x in range(image_width):
    for y in range(image_height):
        if image.get_at((x, y))[3] > 0:
            glVertex2f(x, y)
glEnd()

# Extrude o contorno
vertices = []
arestas = []
for x in range(image_width):
    for y in range(image_height):
        if image.get_at((x, y))[3] > 0:
            vertices.append([x, y, 0])
            vertices.append([x, y, 1])
            idx = len(vertices) - 1
            if idx % 2 == 0:
                arestas.append([idx, idx+1])
            else:
                arestas.append([idx-1, idx])

# Crie uma malha PyMesh
mesh = pymesh.form_mesh(vertices, arestas)

# Salve a malha em um arquivo OBJ
pymesh.save_mesh('meu_objeto.obj', mesh)

# Renderize o resultado na janela
pygame.display.flip()

while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            quit()
