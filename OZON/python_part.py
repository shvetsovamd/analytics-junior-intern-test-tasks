import random

def merge(lst):
    print(*lst)
    if len(lst) < 2:
        return
    new_lst = []
    for i in range(len(lst) // 2 + len(lst) % 2):
        new_lst.append(lst[i] - lst[-i - 1])
    return merge(new_lst)


lst = [0, 1, 2, 0, 5, 10, 13, 4, 3, 3, 13, 1, 22, 2, 8, 10, 0, 8, 5]

print('1. Четные числа:', *list(filter(lambda x: x % 2 == 0, lst)))
print()
print('2. Числа и количество их повторений:')
for key, val in {elem: lst.count(elem) for elem in set(lst)}.items():
    print('число {} повторяется {} раз(а)'.format(key, val))
print()
print('3. Числа на нечетных позициях:', *lst[1::2])
print()
print('4. Произведение всех ненулевых чисел:', eval(' * '.join(list(map(lambda x: '1' if x == 0 else str(x), lst)))))
print()
sorted_set = sorted(set(lst))
print('5. Список разниц между соседними уникальными числами, ' +
      'которые отсортированы по возрастанию', [sorted_set[i + 1] - sorted_set[i] for i in range(len(sorted_set) - 1)])
print()
print('6. Перевернутый массив:', lst[::-1])
print()
print('7. Среднее значение:', sum(lst) / len(lst))
print()
a, b, ln = random.randint(0, 10 ** 9), random.randint(0, 10 ** 9), random.randint(1, 101)
a, b = min(a, b), max(a, b)
print('8. Произвольный отрезок значений в произвольном диапазоне:', [random.randint(a, b) for _ in range(ln)])
print('- произвольный диапазон от {} до {} (не включительно)\n- произвольно выбранная длина от 1 до 100 - {}'.format(a, b, ln))
print()
print('9. Массив, где 1й элемент - разница между первым значением и последним,',
      '2й – разница между 2м и предпоследним и т.д.',
      'Для получившегося массива повторим процедуру, пока не получится одно число.', sep=' ')
merge(lst)
