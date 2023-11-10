import numpy as np
import matplotlib.pyplot as plt

def mandelbrot(c, maxiter):
    z = 0
    n = 0
    while abs(z) < 2 and n < maxiter:
        z = z**2 + c
        n += 1
    if n == maxiter:
        return 0
    else:
        return n

xmin, xmax, ymin, ymax = -2, 1, -1.5, 1.5
resolution = 1000
maxiter = 1000

x = np.linspace(xmin, xmax, resolution)
y = np.linspace(ymin, ymax, resolution)
mandelbrot_set = np.zeros((resolution, resolution))

for i in range(resolution):
    for j in range(resolution):
        mandelbrot_set[j, i] = mandelbrot(complex(x[i], y[j]), maxiter)

plt.imshow(mandelbrot_set.T, cmap='hot', extent=[xmin, xmax, ymin, ymax])
plt.axis('off')
plt.show()
