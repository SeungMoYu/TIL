#인공지능 1번 과제 외판원 문제.

#데이터 파일 읽기
file = open("point20.txt", "r")
text = file.read().split()
data = [eval(i) for i in text]
#print(data)

#city_count = data[0]
city_count = 20
city_coords = []
for i in range(1, len(data), 2):
    city_coords.append((data[i], data[i+1]))
print(city_coords)

#두 도시 좌표 사이의 거리 구하기
import math
def GetDistance(coord1, coord2):
    return math.sqrt((coord1[0] - coord2[0])**2 + (coord1[1] - coord2[1])**2)

# 도시 사이의 거리 미리 구해놓기
distance = [[0 for i in range(city_count)] for j in range(city_count)]
for i in range(city_count -1):
    for j in range(i+1, city_count):
        distance[i][j] = GetDistance(city_coords[i], city_coords[j])
        distance[j][i] = distance[i][j]

#itertools.permutations()를 사용하여 각 경로(순열)의 거리를 구하고
#현재 best거리보다 더 짧은 거리가 나오면 shortest값 갱신
import itertools
import time
def FindShortestPath():
    start_time = time.time()
    print(start_time)
    shortest_distance = math.inf
    shortest_path = None
    
    iter = itertools.permutations(range(1, city_count))
    for path in iter:
        dist = distance[0][path[0]]
        for i in range(len(path)-1):
            dist += distance[path[i]][path[i+1]]
        dist += distance[path[-1]][0]

        if dist < shortest_distance:
            shortest_distance = dist
            shortest_path = path
            print(shortest_distance, path)
            DrawTour(path)
        if time.time() >= (start_time+600):
            print("10분 초과")
            raise TimeoutError()

    print(city_count,"개의 도시 탐색 끝")
    finish_time = time.time()
    print("수행시간 : ", finish_time - start_time)

#GUI : 경로에 따라 그림그리기
#tour : 시작도시(0)를 제외한 경로 (예, [1, 2, 3, 4, 5])
def DrawTour(path):
    canvas.delete(tk.ALL)
    x, y=city_coords[0]
    canvas.create_oval(x - 5, y - 5, x + 5, y + 5, fill="red")
    
    for city in path:
        next_x, next_y = city_coords[city]
        canvas.create_line(x, y, next_x, next_y)
        x, y= next_x, next_y
        canvas.create_oval(x - 5, y - 5, x + 5, y + 5, fill="blue")
    #for i in range(city_count):  연습
    #    x, y = city_coords[i]
    #    canvas.create_oval(x - 5, y - 5, x + 5, y + 5, fill="blue")
    next_x, next_y = city_coords[0]
    canvas.create_line(x, y, next_x, next_y)


#gui화면 구성
import tkinter as tk
import threading
window = tk.Tk()
canvas = tk.Canvas(window, width = 600, height = 600, bg = "white")
canvas.pack(expand = 1, fill =tk.BOTH)
btn = tk.Button(window, text = "Start", command = lambda : threading.Thread(target =FindShortestPath).start())
btn.pack(fill = tk.X)
DrawTour(list(range(1, city_count)))

window.mainloop()
